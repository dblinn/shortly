var ShortlyIndex = {};

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
    link.text(originalUrl);
    link.attr('href', originalUrl);
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

  this.onFormSubmission = function(event) {
    var jsSubmissionForm = event.data;

    var urlToShorten = jsSubmissionForm.shortlyInput.val();
    $.post('/shorten', { url: urlToShorten })
      .success($.proxy(jsSubmissionForm.shortenUrlSuccess, jsSubmissionForm))
      .fail($.proxy(jsSubmissionForm.shortenUrlFailure, { form: jsSubmissionForm, originalUrl: urlToShorten }));

    return false;
  };

  this.onInputChange = function(event) {
    var jsSubmissionForm = event.data;
    jsSubmissionForm.invalidUrlText.addClass('hidden');
  };

  this.initializeSubmissionForm = function() {
    $('#shortly-form').submit(this, this.onFormSubmission);
    this.shortlyInput.keypress(this, this.onInputChange);
  };

  this.shortenUrlSuccess = function(data) {
    if (data.success) {
      this.addShortenResult(
        $('#success-seed'),
        'short-link-text',
        data.short_url,
        data.original_url,
        true
      );
    }
    else {
      this.showInvalidUrlText(data.original_url);
    }
  };

  this.shortenUrlFailure = function() {
    this.form.addShortenResult(
      $('#failure-seed'),
      'failure-message',
      'Looks like something went wrong :(',
      this.originalUrl,
      false
    );
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
