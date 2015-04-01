$(document).ready(function() {
  // On form submit, we stop submission to go get the token
  $('form').on('submit', function (event) {
    event.preventDefault();
    var $form = $(this);

    // Disable the submit button
    $('#subscribe').prop('disabled', true);
    //clear_errors();

    Stripe.card.createToken($form, stripeResponseHandler);

    // Prevent the form from submitting with the default action
    return false;
  });


  // Identity card type
  $("#number").on('blur', function(event) {
    var cardNumber = $("#number").val()
    var cardIsValid = $.payment.validateCardNumber(cardNumber)

    if(cardIsValid) {
      $("#number").removeClass('form-input__error');
    }
    else {
      $("#number").addClass('form-input__error');
    }
  });
});
