$(document).ready(function () {
  function arrayRemove(arr, value) {
    return arr.filter(function (ele) {
      return ele != value;
    });
  }

  var consonant_inc = [];
  var consonant_exc = [];
  var vowel_inc = [];
  var vowel_exc = [];
  var c_query = [];
  var v_query = [];
  var c_query_string = "";
  var v_query_string = "";
  var stop = false;
  var v_stop = false;

  $(function () {
    $.ajax({
      url: "/segments",
      type: "GET",
      async: false,
      cache: "true",
      dataType: "json",
      success: function (segments) {
        var no = 0;
        $.each(segments, function (no, segment) {
          no = no + 1;
          var $rows = $("#myTable5 tbody tr");
          for (i = 1; i <= 18; i++) {
            var colText = $(`#myTable5 tr:eq(0) td:eq(${i})`)
              .text()
              .toLowerCase(); // First row, find which column
            if (colText === segment.place.toLowerCase()) {
              var colNo = i;
              break;
            }
          }

          for (j = 1; j <= 15; j++) {
            var rowText = $(`#myTable5 tr:eq(${j}) td:eq(0)`)
              .text()
              .toLowerCase(); // First column, find which row
            if (rowText === segment.manner.toLowerCase()) {
              var rowNo = j;
              break;
            }
          }

          if (segment.number == 0) {
            $(`#myTable5 tr:eq(${rowNo}) td:eq(${colNo})`).append(
              '<span class="zero">' + segment.ipa + "</span>"
            );
          } else {
            $(`#myTable5 tr:eq(${rowNo}) td:eq(${colNo})`).append(
              "<span>" + segment.ipa + "</span>"
            );
          }

          if (no == segments.length) {
            stop = true;
          }

          if (stop) {
            $("#consonants_table span").click(function (e) {
              handle_click(this);
            });
          }
        });
      },
    });

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
            $("#vowels_table span").click(function (e) {
              handle_click(this);
            });
          }
        });
      },
    });
  });

  function handle_click(span) {
    var tableId = $(span).closest("table").parent().parent().attr("id");
    if (tableId == "vowels_table") {
      var vowel_text = $(span).text();
    } else {
      var consonant_text = $(span).text();
    }

    if (span != null) {
      var o = $(span);
      var oi = o.attr("f");
      if (oi == "-1") {
        $("#chooser span").each(function () {
          $(this).removeClass("yes no");
        });
        consonant_inc = [];
        consonant_exc = [];
        c_query = [];
      } else if (o.hasClass("yes")) {
        if (tableId == "consonants_table") {
          consonant_exc.push(consonant_text);
          consonant_inc = arrayRemove(consonant_inc, consonant_text);
          minus_text = "-" + consonant_text;
          c_query.push(minus_text);
          c_query = arrayRemove(c_query, consonant_text);
        } else {
          vowel_exc.push(vowel_text);
          vowel_inc = arrayRemove(vowel_inc, vowel_text);
          minus_text = "-" + vowel_text;
          v_query.push(minus_text);
          v_query = arrayRemove(v_query, vowel_text);
        }

        o.removeClass("yes");
        o.addClass("no");
        //console.log("consonant_inc: " + consonant_inc + " | consonant_exc: " + consonant_exc);
        //console.log("c_query: " + c_query);
      } else if (o.hasClass("no")) {
        if (tableId == "consonants_table") {
          consonant_exc = arrayRemove(consonant_exc, consonant_text);
          minus_text = "-" + consonant_text;
          c_query = arrayRemove(c_query, minus_text);
          o.removeClass("no");
        } else {
          vowel_exc = arrayRemove(vowel_exc, vowel_text);
          minus_text = "-" + vowel_text;
          v_query = arrayRemove(v_query, minus_text);
          o.removeClass("no");
        }
        //console.log("consonant_inc: " + consonant_inc + " | consonant_exc: " + consonant_exc);
        //console.log("c_query: " + c_query);
      } else {
        if (tableId == "consonants_table") {
          consonant_inc.push(consonant_text);
          c_query.push(consonant_text);
        } else {
          vowel_inc.push(vowel_text);
          v_query.push(vowel_text);
        }
        //console.log("consonant_inc: " + consonant_inc + " | consonant_exc: " + consonant_exc);
        //console.log("c_query: " + c_query);
        o.addClass("yes");
      }
    }
    console.log(c_query);
    console.log(v_query);
    c_query_string = c_query.join(" ");
    v_query_string = v_query.join(" ");
    console.log("c_query_string:" + c_query_string);
    console.log("v_query_string:" + v_query_string);

    $("#c_query").val(c_query.join(" "));

    $.ajax({
      url: "/papuas",
      type: "GET",
      cache: "true",
      dataType: "script",
      data: `inv=${c_query_string}&vowels=${v_query_string}`,
      success: function (data) {
        //console.log(data);
      },
    });
  }
});
