// https://observablehq.com/@blainerothrock/untitled@272
export default function define(runtime, observer) {
  const main = runtime.module();
  main.variable(observer("d3")).define("d3", ["require"], function(require){return(
require("d3@5")
)});
  main.variable(observer("all_allegations_by_cat")).define("all_allegations_by_cat", ["d3"], function(d3){return(
d3.csv('https://gist.githubusercontent.com/blainerothrock/7e66dc795c8769650ba9342423894771/raw/6f66964b14c729cf85a4123e6812d276de75c269/cpdp_allegations_by_category.csv')
)});
  main.variable(observer("all_sustained_by_cat")).define("all_sustained_by_cat", ["d3"], function(d3){return(
d3.csv('https://gist.githubusercontent.com/blainerothrock/a4cb968ad28aabe86a361fcf88df2ffc/raw/46a64d126a77d079471fafe41adb7f3ab875dc38/all_sustained_count_by_cat.csv')
)});
  main.variable(observer("first_allegation_by_cat")).define("first_allegation_by_cat", ["d3"], function(d3){return(
d3.csv('https://gist.githubusercontent.com/blainerothrock/6c5a4727a6295d87383ba261b1b1ed17/raw/45756d16cfeaa20e0a3e4af69b5c858e79de95ba/cpdp_first_allegations_by_category.csv')
)});
  main.variable(observer("year")).define("year", function(){return(
'2001'
)});
  main.variable(observer("first_allegations")).define("first_allegations", ["first_allegation_by_cat","year"], function(first_allegation_by_cat,year){return(
first_allegation_by_cat.filter((a) => a.year == year)
)});
  main.variable(observer("all_allegations")).define("all_allegations", ["all_sustained_by_cat","year"], function(all_sustained_by_cat,year){return(
all_sustained_by_cat.filter((a) => a.year == year)
)});
  main.variable(observer("all_sustained_allegations")).define("all_sustained_allegations", ["all_sustained_by_cat","year"], function(all_sustained_by_cat,year){return(
all_sustained_by_cat.filter((a) => a.year == year)
)});
  main.variable(observer("height")).define("height", function(){return(
600
)});
  main.variable(observer("margin")).define("margin", function(){return(
{top: 20, right: 30, bottom: 30, left: 40}
)});
  main.variable(observer("max_first_allegation_count")).define("max_first_allegation_count", ["d3","first_allegation_by_cat"], function(d3,first_allegation_by_cat){return(
d3.max(first_allegation_by_cat, function (d) { return parseInt(d.count) + 25; })
)});
  main.variable(observer("x")).define("x", ["d3","max_first_allegation_count","margin","width"], function(d3,max_first_allegation_count,margin,width){return(
d3.scaleLinear()
    .domain([-10, max_first_allegation_count])
    .range([margin.left, width - margin.right])
)});
  main.variable(observer("max_all_allegation_count")).define("max_all_allegation_count", ["d3","all_allegations_by_cat"], function(d3,all_allegations_by_cat){return(
d3.max(all_allegations_by_cat, function (d) { return parseInt(d.count) + 50; })
)});
  main.variable(observer("y")).define("y", ["d3","max_all_allegation_count","height","margin"], function(d3,max_all_allegation_count,height,margin){return(
d3.scaleLinear()
    .domain([-25, max_all_allegation_count])
    .range([height - margin.bottom, margin.top])
)});
  main.variable(observer("xAxis")).define("xAxis", ["height","margin","d3","x","width"], function(height,margin,d3,x,width){return(
g => g
    .attr("transform", `translate(0,${height - margin.bottom})`)
    .call(d3.axisBottom(x))
    .call(g => g.select(".domain").remove())
    .call(g => g.append("text")
        .attr("x", width - margin.right)
        .attr("y", -4)
        .attr("fill", "#000")
        .attr("font-weight", "bold")
        .attr("text-anchor", "end")
        .text('First Time Allegation Count'))
)});
  main.variable(observer("yAxis")).define("yAxis", ["margin","d3","y"], function(margin,d3,y){return(
g => g
    .attr("transform", `translate(${margin.left},0)`)
    .call(d3.axisLeft(y))
    .call(g => g.select(".domain").remove())
    .call(g => g.select(".tick:last-of-type text").clone()
        .attr("x", 4)
        .attr("text-anchor", "start")
        .attr("font-weight", "bold")
        .text('Total Allegation Count'))
)});
  main.variable(observer("colorRange")).define("colorRange", ["d3","all_allegations"], function(d3,all_allegations){return(
d3.scaleOrdinal().domain(all_allegations.map((a) => { return a.category }))
  .range(d3.schemeSet3)
)});
  main.variable(observer("interpolateData")).define("interpolateData", ["all_allegations_by_cat","first_allegation_by_cat","all_sustained_by_cat"], function(all_allegations_by_cat,first_allegation_by_cat,all_sustained_by_cat){return(
(year) => {
  return all_allegations_by_cat.filter((a) => parseInt(a.year) == year).map((all) => {
    const first = first_allegation_by_cat.filter((a) => a.year == all.year && a.category == all.category)
    var first_count = 0
    if ( first != undefined && first.length == 1 ) { first_count = parseInt(first[0].count) }
    
    const sustained = all_sustained_by_cat.filter((a) => a.year == all.year && a.category == all.category)
    var sustained_percentage = 0
    if ( sustained != undefined && sustained.length == 1 ) { 
      sustained_percentage = parseInt(sustained[0].count) / parseInt(all.count) 
    }

    return {
      "category": all.category,
      "year": all.year,
      "all_count": parseInt(all.count),
      "first_count": first_count,
      "sustained_percent": sustained_percentage
    }
  })
}
)});
  main.variable(observer("chart")).define("chart", ["d3","width","height","xAxis","yAxis","x","y","interpolateData","colorRange"], function(d3,width,height,xAxis,yAxis,x,y,interpolateData,colorRange)
{
  const svg = d3.create("svg")
      .attr("viewBox", [0, 0, width, height]);

  svg.append("g")
      .call(xAxis);
       
  svg.append("g")
      .call(yAxis);
  
  const tooltip = svg
    .append("div")
    .style("opacity", 0)
    .attr("class", "tooltip")
    .style("background-color", "white")
    .style("border", "solid")
    .style("border-width", "1px")
    .style("border-radius", "5px")
    .style("padding", "10px")

  const circles = svg.append("g")
    .attr("class", "circles"); 
  
  const position = (cir) => {
    cir
      .attr("r", (d) => {
        return Math.max(d.sustained_percent * 2, 5)
       })
      .attr("cx", (d) => x(d.first_count))
      .attr("cy", (d) => y(d.all_count))
  }
  
  const circle = circles.selectAll(".circle")
      .data(interpolateData(2003))
      .enter().append("circle")
        .attr("class", "circle")
        .attr("stroke", (d) => { return colorRange(d.category) })
        .attr("stroke-width", 1.5)
        .attr("fill", (d) => { return colorRange(d.category) })
        .attr("id", (d) => { return d.category })
        .call(position)
  
  svg.transition()
    .duration(10000)
    .ease(d3.easeLinear)
    .tween("year", () => {
      var year = d3.interpolateNumber(2000, 2016);
      return function(t) {
        console.log(Math.round(year(t)))
        circle.data(interpolateData(Math.round(year(t))), (d) => d.category).call(position);
      };
    })


  return svg.node();
}
);
  return main;
}
