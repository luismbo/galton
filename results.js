$(function () {
    Highcharts.setOptions({
        credits: { enabled: false },
        tooltip: { pointFormat: "{point.y}" },
        legend: { enabled: false }
    });

    $.getJSON("data", function(data) {
        $.each(data, function(i, info) {
            if (info.type === "section") {
                $("#contents").append("<h2 class='clear'>" + info.title + "</h2>");
               
            } else { /* charts */
                $("#contents").append("<h3 class='clear'>" + info.title + "</h3>");

                var data = info.chart.series[0].data;

                var height = 250;
                if (info.type === "checkboxes")
                    height = data.length * 35;

                $("<div class='graph' style='height: " + height + "px'>")
                    .appendTo("#contents").highcharts(info.chart);

                if (info.type !== "month") {
                    var total = 0;
                    $.each(data, function(i, item) { total += item[1]; });

                    var table = $("<table class='response-summary-table'>")
                        .appendTo("#contents");

                    $.each(data, function(i, item) {
                        var tr = $("<tr>").appendTo(table);
                        tr.append("<td class='table-label'>" + item[0] + "</td>");
                        tr.append("<td class='table-number'>" + item[1] + "</td>");
                        tr.append("<td class='table-percentage'>" +
                                  (item[1]/total*100).toFixed(0) + "%</td>");
                    });
                }
            }
        });
    }).error(function(jqXHR, status, err) {
        console.log("JSON error: " + status + ': ' + err);
    });
});
