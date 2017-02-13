var dashboardApp = angular.module('DashBoard', ["ui.sortable"]);

dashboardApp.factory('summaryData', ['$http', function($http){
  return {
    index: function(search, callback){
      if (!search){
        search = ""
      }else{
        search = "?search="+search;
      }
      $http.get("/datacards" + search).then(callback);
    },
    show: function(d1, d2, search, callback){
      $http.get("datacard?start=" + d1 + "&end="+ d2 + "&search=" + search).then(callback);
    },
    detail: function(d1, d2, attr, callback){
      $http.get("datadetail?start=" + d1 + "&end="+ d2 + "&attribute=" + attr).then(callback);
    },
    getAll: function(callback){
      $http.get("mobile-summary").then(callback);
    }
  };
}]);

dashboardApp.controller("CardListCtrl", ["$scope", "summaryData", function($scope, summaryData){
  $scope.search = "";
  $scope.loading = true;
  $scope.filterHide = true;
  $scope.searchFilterHide = true;
  $scope.start_date = new Date((new Date).getTime() - (7 * 24 * 60 * 60 * 1000));
  $scope.end_date = new Date;
  $scope.choice_by = "";
  $scope.modalShow = false;
  $scope.currentActive = 'cards';
  $scope.attrMap = {
    sunday: "Sunday Attendance",
    ft: "First Timers",
    newConv: "New Converts",
    nbs: "Started NBS",
    fnbs: "Finished NBS",
    bap: "Baptised",
    tithe: "First &amp; Best"
  }
  $scope.filterToggle = function(){
    $scope.filterHide = !$scope.filterHide;
  }
  $scope.searchFilterToggle = function(){
    $scope.searchFilterHide = !$scope.searchFilterHide;
  }
  $scope.Math = window.Math;
  $scope.addOne = function(card){
    card.sunday_att += 1;
  };
  $scope.reloadData = function(){
    $scope.loading = true;
    summaryData.index($scope.search, function(cards){
      $scope.cards = cards.data;
      $scope.loading = false;
      $scope.search = ""
      $scope.filterHide = true;
      $scope.searchFilterHide = true;
    })
  }

  $scope.searchData = function(){
    // $scope.loading = true;
    summaryData.show($scope.start_date.toISOString().split("T")[0], $scope.end_date.toISOString().split("T")[0], $scope.searchTerm, function(card){
      $scope.card = card.data;
      // $scope.searchFilterHide = false;
      $scope.hasSearched = true;
    })
  }
  $scope.getAllCard = function(){
    summaryData.show($scope.start_date.toISOString().split("T")[0], $scope.end_date.toISOString().split("T")[0], "", function(card){
      $scope.card = card.data;
      // $scope.searchFilterHide = false;
      $scope.hasSearched = true;
    })
  };
  $scope.updateDate = function(){
    if($scope.hasSearched) $scope.searchData();
  }
  $scope.reloadData();
  $scope.detailLoading = true;
  summaryData.getAll(function(data){
    $scope.allData = data.data;
    console.log(data.data);
    $scope.setBaseChartData();
    $scope.detailLoading = false;
    // $scope.showModal();
    $scope.chart = $scope.drawChart();
  });
  $scope.toggleCard = function(card){
    card.show = !card.show;
  }
  $scope.showModal = function(name, mob_name, attr, attr_name){
    $scope.modalHeader = attr_name || $scope.modalHeader;
    $scope.subHeader = name || $scope.subHeader;
    $scope.cardName = mob_name || $scope.cardName
    $scope.chartAttr = attr || $scope.chartAttr;
    $scope.currentActive = 'charts';
    $scope.reDrawChart();
  }
  $scope.reDrawChart = function(){
    $scope.modalHeader = $scope.attrMap[$scope.chartAttr];
    $scope.subHeader = $scope.cardName;
    if ($scope.chartData){
      $scope.chartData = [];
      if($scope.compareGrouping == "region"){
        for (var region in $scope.allData.totals_by_region){
          $scope.chartData.push([region, +$scope.allData.totals_by_region[region][$scope.cardName][$scope.chartAttr]])
        }
      }else if($scope.compareGrouping == "city"){
        for (var region in $scope.allData.totals_by_city){
          $scope.chartData.push([region, +$scope.allData.totals_by_city[region][$scope.cardName][$scope.chartAttr]])
        }
      }else if($scope.compareGrouping == "church_group"){
        for (var region in $scope.allData.totals_by_group){
          $scope.chartData.push([region, +$scope.allData.totals_by_group[region][$scope.cardName][$scope.chartAttr]])
        }
      }

      setTimeout(function(){
        $scope.chart = $scope.drawChart();
      }, 100)
    }
  }
  $scope.modalHeader = "Sunday Attendance";
  $scope.subHeader = "Last 12 Months";
  $scope.compareGrouping = "region";
  $scope.chartAttr = 'sunday';
  $scope.cardName = "Last 12 months"
  $scope.setBaseChartData = function(){
    $scope.chartData = [];
    for (var region in $scope.allData.totals_by_region){
      $scope.chartData.push([region, +$scope.allData.totals_by_region[region]["Last 12 months"].sunday])
    }
  };
  $scope.drawChart = function(options){
    return new Highcharts.chart({
        credits: {
          enabled: false
        },
        chart: {
            renderTo: 'chartContainer',
            plotBackgroundColor: null,
            plotBorderWidth: 0,
            plotShadow: false
        },
        xAxis: {
             categories: $scope.chartData.filter(function(ele){ return ele[1] > 0}).map(function(ele){return ele[0] + " - " + ele[1];}),
             title: {
                 text: null
             },
             labels: {
              style: {size: '#a9a9a9', fontSize: '14px'}
             }
         },
        yAxis: {
          title: {
            text: null
          },
          lineWidth: 0,
          gridLineWidth: 0,
          minorGridLineWidth: 0,
          lineColor: 'transparent',
             labels: {
               enabled: false
             },
          minorTickLength: 0,
          tickLength: 0
        },
        legend: {
            enabled: false,
            layout: 'vertical',
            verticalAlign: 'middle',
            align: 'right',
            itemStyle: {
                color: 'white',
                fontWeight: 'bold',
                fontSize: '14px',
            }
        },
        title: {
            text: $scope.modalHeader,
            margin: 20,
            style: {color: '#f9f9f9'}
        },
        subtitle: {
            text: $scope.subHeader,
            style: {color: '#c9c9c9'}
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.y:.0f}</b>'
        },
        plotOptions: {
            bar: {
              dataLabels: {
                enabled: true,
                align: 'left',
                style: {
                  color: '#f9f9f9',
                  fontWeight: 'normal',
                  fontSize: '14px'
                }
              }
            },
            pie: {
                dataLabels: {
                    enabled: true,
                    distance: -50,
                    style: {
                        fontWeight: 'bold',
                        color: 'white'
                    }
                },
                startAngle: -90,
                endAngle: 90,
                center: ['50%', '75%']
            }
        },
        series: [{
          type: 'bar',
          name: $scope.modalHeader,
          data: $scope.chartData.filter(function(ele){return ele[1] > 0 })
        }]
    });
  }

}])
