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
  $scope.toggleCard = function(card){
    console.log('called');
    card.show = !card.show;
    console.log(card);
  }
  $scope.closeModal = function(){
    $scope.modalShow = false;
  }
  $scope.showModal = function(card, attr, attr_name){
    $scope.detailLoading = true;
    $scope.modalHeader = attr_name;
    $scope.chosenCard = card
    $scope.modalShow = true;
    summaryData.detail(card.start_date, card.end_date, attr, function(card){
      console.log(card);
      $scope.detailLoading = false;
      $scope.chart = $scope.drawChart();
    })
    $scope.chart.reflow();
  }
  $scope.drawChart = function(options){
    return new Highcharts.chart({
        chart: {
            renderTo: 'chartContainer',
            plotBackgroundColor: null,
            plotBorderWidth: 0,
            plotShadow: false
        },
        title: {
            text: $scope.modalHeader,
            align: 'center',
            verticalAlign: 'middle',
            y: 40
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
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
            type: 'pie',
            name: 'Browser share',
            innerSize: '30%',
            data: [
                ['Firefox',   10.38],
                ['IE',       56.33],
                ['Chrome', 24.03],
                ['Safari',    4.77],
                ['Opera',     0.91],
                {
                    name: 'Proprietary or Undetectable',
                    y: 0.2,
                    dataLabels: {
                        enabled: false
                    }
                }
            ]
        }]
    });
  }

  $scope.sortableOptions = {
    cursor: 'move'
  }
}])
