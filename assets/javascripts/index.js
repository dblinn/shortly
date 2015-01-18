var ShortlyIndex = {};
ShortlyIndex.submissionForm = function() {

  this.shortlyInput = $('#shortly-input');
  this.shortenedResponses = $('#shortened-responses');

  this.onFormSubmission = function(event) {
    var jsSubmissionForm = event.data;

    var urlToShorten = jsSubmissionForm.shortlyInput.val();
    $.post('/shorten', { url: urlToShorten })
      .success(jsSubmissionForm.shortenUrlSuccess)
      .fail(jsSubmissionForm.shortenUrlFailure);

    return false;
  };

  this.initializeSubmissionForm = function() {
    $('#shortly-form').submit(this, this.onFormSubmission);
  };

  this.shortenUrlSuccess = function(data, textStatus) {
    console.log('Success');
    console.log(data);
    console.log(this);

    this.shortenedResponses.append();
  };

  this.shortenUrlFailure = function(data, textStatus) {
    console.log('Failure');
  };
};

$(document).ready(function() {
  (new ShortlyIndex.submissionForm()).initializeSubmissionForm();
});
