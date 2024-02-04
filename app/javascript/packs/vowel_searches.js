$(document).ready(function () {
  function arrayRemove(arr, value) {
    return arr.filter(function (ele) {
      return ele != value;
    });
  }

  var inc = [];
  var exc = [];
  var query = [];
  var query_string = "";
  var v_stop = false;

  $(function () {
    $.ajax({
      url: "/vowels",
      type: "GET",
      async: false,
      cache: "true",
      dataType: "json",
      success: function (vowels) {
        $.each(vowels, function (no, vowel) {
          no = no + 1;
          var $rows = $("#myTable6 tbody tr");
          colNo = vowel.short.toLowerCase() === "yes" ? 1 : 2;
          rowNo = vowel.nasalised.toLowerCase() === "yes" ? 1 : 2;

          $(`#myTable6 tr:eq(${rowNo}) td:eq(${colNo})`).append(
            "<span>" + vowel.ipa + "</span>"
          );

          if (no == vowels.length) {
            v_stop = true;
          }

          if (v_stop) {
            $("#chooser span").click(function (e) {
              handle_click(this);
            });
          }
        });
      },
    });
  });

  function handle_click(span) {
    var text = $(span).text();
    if (span != null) {
      var o = $(span);
      var oi = o.attr("f");
      if (oi == "-1") {
        $("#chooser span").each(function () {
          $(this).removeClass("yes no");
        });
        inc = [];
        exc = [];
        query = [];
      } else if (o.hasClass("yes")) {
        exc.push(text);
        inc = arrayRemove(inc, text);
        minus_text = "-" + text;
        query.push(minus_text);
        query = arrayRemove(query, text);

        o.removeClass("yes");
        o.addClass("no");
        //console.log("inc: " + inc + " | exc: " + exc);
        //console.log("query: " + query);
      } else if (o.hasClass("no")) {
        exc = arrayRemove(exc, text);
        minus_text = "-" + text;
        query = arrayRemove(query, minus_text);
        o.removeClass("no");
        //console.log("inc: " + inc + " | exc: " + exc);
        //console.log("query: " + query);
      } else {
        inc.push(text);
        query.push(text);
        //console.log("inc: " + inc + " | exc: " + exc);
        //console.log("query: " + query);
        o.addClass("yes");
      }
    }
    console.log(query);
    query_string = query.join(" ");
    console.log(query_string);

    $("#query").val(query.join(" "));

    $.ajax({
      url: "/papuas",
      type: "GET",
      cache: "true",
      dataType: "script",
      data: `inv=${query_string}`,
      success: function (data) {
        //console.log(data);
      },
    });
  }

  // $('#chooser span').click(function(e) {
  // 	handle_click(this);
  // });

  //handle_click(null);
});
