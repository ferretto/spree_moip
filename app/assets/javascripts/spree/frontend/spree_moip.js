var SpreeMoip = {
  success: function(data) {
    window.open(data.url);
  },
  failure: function(data) {
    alert('Fail\n' + JSON.stringify(data));
  },
  generateSlip: function() {
    $.ajax({
      type: "POST",
      dataType: "json",
      url: "/moip/generate_token",
      data: {payment_method_id: SpreeMoip.paymentMethodId},
      success: function(data){
        $( "#MoipWidget" ).attr( "data-token", data.token );
        var settings = {
          "Forma": "BoletoBancario"
        }
        MoipWidget(settings);
      }
    });
  }
}
