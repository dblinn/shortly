var ShortlyIndex = {};
ShortlyIndex.submissionForm = function() {

  this.onFormSubmission = function(event) {
    var jsSubmissionForm = event.data;

    var urlToShorten = $('#shortly-input').val();
    $.post('/shorten', { url: urlToShorten })
      .success(jsSubmissionForm.shortenUrlSuccess)
      .fail(jsSubmissionForm.shortenUrlFailure);

    return false;
  };

  this.initializeSubmissionForm = function() {
    $('#shortly-form').submit(this, this.onFormSubmission);
  };

  this.shortenUrlSuccess = function() {
    console.log('Success');
  };

  this.shortenUrlFailure = function() {
    console.log('Failure');
  };
};

$(document).ready(function() {
  (new ShortlyIndex.submissionForm()).initializeSubmissionForm();
});
