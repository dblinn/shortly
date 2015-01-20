var ShortlyIndex = ShortlyIndex || {};

ShortlyIndex.shortResult = function(seedElement) {
  this.seedElement = seedElement;

  this.setResultText = function(resultTextName, resultTextMessage, isLink) {
    var resultText = this.seedElement.find('.' + resultTextName);
    resultText.text(resultTextMessage);
    if (isLink) {
      resultText.attr('href', resultTextMessage);
    }
  };

  this.setOriginalUrl = function(originalUrl) {
    var link = this.seedElement.find('.full-link-link');
    link.text(Shortly.urlWithoutScheme(originalUrl));
    link.attr('href', Shortly.urlWithScheme(originalUrl));
  };

  this.setupResult = function(resultTextName, resultTextMessage, success, originalUrl) {
    this.setResultText(resultTextName, resultTextMessage, success);
    this.setOriginalUrl(originalUrl);
  }
};

ShortlyIndex.submissionForm = function() {

  this.shortlyInput = $('#shortly-input');
  this.shortenedResponses = $('#shortened-responses');
  this.invalidUrlText = $('.invalid-url-text');
  this.submitButton = $('#shortly-shorten-button');
  this.formSubmitEnabled = true;

  this.onFormSubmission = function(event) {
    var jsSubmissionForm = event.data;

    var urlToShorten = jsSubmissionForm.shortlyInput.val();
    var validatedUrl = Shortly.validatedUrl(urlToShorten);
    if (jsSubmissionForm.formSubmitEnabled) {
      jsSubmissionForm.performSubmission(urlToShorten, validatedUrl);
    }

    return false;
  };

  this.performSubmission = function(urlToShorten, validatedUrl) {
    $.post('/shorten', { url: validatedUrl })
      .success($.proxy(this.shortenUrlSuccess, this))
      .fail($.proxy(this.shortenUrlFailure, { form: this, originalUrl: urlToShorten }));

    this.disableSubmission();
  };

  this.onInputChange = function(event) {
    if (event.keyCode == 13) {
      return; // The enter key submits the form.
    }

    var jsSubmissionForm = event.data;
    jsSubmissionForm.invalidUrlText.addClass('hidden');
    jsSubmissionForm.enableSubmission();
  };

  this.onInputKeydown = function(event) {
    if (event.keyCode == 8) { // The backspace key
      var jsSubmissionForm = event.data;
      jsSubmissionForm.invalidUrlText.addClass('hidden');
      jsSubmissionForm.enableSubmission();
    }
  };

  this.disableSubmission = function() {
    this.formSubmitEnabled = false;
    this.submitButton.attr('disabled','disabled');
  };

  this.enableSubmission = function() {
    this.formSubmitEnabled = true;
    this.submitButton.removeAttr('disabled');
  };

  this.initializeSubmissionForm = function() {
    this.enableSubmission();
    $('#shortly-form').submit(this, this.onFormSubmission);
    this.shortlyInput.keypress(this, this.onInputChange);
    this.shortlyInput.keydown(this, this.onInputKeydown);
  };

  this.replaceInputText = function(newText) {
    this.shortlyInput.val(newText);
  };

  this.selectInputText = function() {
    this.shortlyInput.select();
  };

  this.shortenUrlSuccess = function(data) {
    if (data.success) {
      this.replaceInputText(data.short_url);

      this.addShortenResult(
        $('#success-seed'),
        'short-link-text',
        data.short_url,
        data.source_url,
        true
      );
    }
    else {
      this.showInvalidUrlText(data.source_url);
    }

    this.selectInputText();
  };

  this.shortenUrlFailure = function() {
    this.form.addShortenResult(
      $('#failure-seed'),
      'failure-message',
      'Looks like something went wrong :(',
      this.originalUrl,
      false
    );

    this.enableSubmission();
    this.selectInputText();
  };

  this.showInvalidUrlText = function(originalUrl) {
    this.invalidUrlText.text(
      'Oops! "' + originalUrl + '" does not appear to be a valid URL'
    );
    this.invalidUrlText.removeClass('hidden');
  };

  this.addShortenResult = function(seedElement, resultTextName, resultTextMessage, originalUrl, success) {
    var resultNode = seedElement.children().clone(false, true);
    var resultObject = new ShortlyIndex.shortResult(resultNode);
    resultObject.setupResult(resultTextName, resultTextMessage, success, originalUrl);

    this.shortenedResponses.prepend(resultNode);
  };
};

$(document).ready(function() {
  (new ShortlyIndex.submissionForm()).initializeSubmissionForm();
});
