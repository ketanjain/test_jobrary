var axisColor = pv.color("#e3e3e3"),
    barColor = pv.color("#6fc46f"),
    pieColors = [pv.color("#ff871e"),pv.color("#fbc701")],
    lineColor = pv.color("#64adda"),
    axesLabelColor = pv.color("#afb9bf"),
    axesLabelFont = "11px sans-serif";

function renderCtReductionChart(data)
{
    /* Sizing and scales. */
    var width = 140,
    height = 180,
    totalBarWidth = 50,
    barMargin = 20,
    yScale = pv.Scale.linear(0, 1).range(0, height);

    totalBarWidth = width/data.length;
    barMargin = 0.20 * totalBarWidth;

    /* The root panel. */
    var vis = new pv.Panel()
    .width(width)
    .height(height)
    .top(20)
    .bottom(30)
    .left(45)
    .right(0);


    /* Y-axis ticks. */
    vis.add(pv.Rule)
    .data(yScale.ticks())
    .strokeStyle(axisColor)
    .bottom(yScale)
    .anchor("left").add(pv.Label)
    .textStyle(axesLabelColor)
    .text(yScale.tickFormat);

    /* Bars */
    vis.add(pv.Bar)
    .data(data)
    .left(function(){return barMargin + this.index * (totalBarWidth)})
    .width(totalBarWidth - (2 * barMargin))
    .fillStyle(barColor)
    .bottom(0)
    .height(function(d){return yScale(d.savings)})
    .anchor("bottom").add(pv.Label)
    .textStyle(pv.color("#afb9bf"))
    .textBaseline("top")
    .text(function(d){return d.percent});
    
    /* X-axis labels. */
    vis.add(pv.Label)
    .right(0)
    .top(210)
    .textAlign("right")
    .textStyle(axesLabelColor)
    .font(axesLabelFont)
    .text("Cycle Time Reduction (%)");

    /* Y-axis labels. */
    vis.add(pv.Label)
    .left(-32)
    .top(0)
    .textAlign("right")
    .textStyle(axesLabelColor)
    .textAngle(4.712)
    .font(axesLabelFont)
    .text("Savings in Energy Consumption");
    vis.add(pv.Label)
    .left(-20)
    .top(100)
    .textAlign("left")
    .textStyle(axesLabelColor)
    .textAngle(4.712)
    .font(axesLabelFont)
    .text("(kWh/part)");
    
    vis.render();
}

function renderUtiImpChart(data)
{
    /* Sizing and scales. */
    var width = 140,
    height = 180,
    totalBarWidth = 50,
    barMargin = 20,
    ymax = pv.max(data, function(d) {return d.savings}),
    yScale = pv.Scale.linear(0, ymax).range(0, height);

    totalBarWidth = width/data.length;
    barMargin = 0.20 * totalBarWidth;

    /* The root panel. */
    var vis = new pv.Panel()
    .width(width)
    .height(height)
    .top(20)
    .bottom(30)
    .left(45)
    .right(0);

    /* Y-axis ticks. */
    vis.add(pv.Rule)
    .data(yScale.ticks())
    .strokeStyle(axisColor)
    .bottom(yScale)
    .anchor("left").add(pv.Label)
    .textStyle(axesLabelColor)
    .text(yScale.tickFormat);

    /* Bars */
    vis.add(pv.Bar)
    .data(data)
    .left(function(){
        return barMargin + this.index * (totalBarWidth)
    })
    .fillStyle(barColor)
    .width(totalBarWidth - (2 * barMargin))
    .bottom(0)
    .height(function(d){
        return yScale(d.savings)
    })
    .anchor("bottom").add(pv.Label)
    .textBaseline("top")
    .textStyle(axesLabelColor)
    .text(function(d){
        return d.percent
    });

    /* X-axis labels. */
    vis.add(pv.Label)
    .right(0)
    .top(210)
    .textAlign("right")
    .textStyle(axesLabelColor)
    .font(axesLabelFont)
    .text("Utilization (%)");

    /* Y-axis labels. */
    vis.add(pv.Label)
    .left(-33)
    .top(0)
    .textAlign("right")
    .textStyle(axesLabelColor)
    .textAngle(4.712)
    .font(axesLabelFont)
    .text("Annualised Savings (USD $)");
    
    vis.render();
}

function renderEnergyUsageChart(data)
{
    /* Sizing and scales. */
    var width = 175,
    height = 250,
    radius = width / 2,
    normalized_data = pv.normalize(data),
    percentage_data = [(normalized_data[0] * 100).toFixed(2), (normalized_data[1] * 100).toFixed(2)];
    
    /* The root panel. */
    var vis = new pv.Panel()
    .width(width)
    .height(height);

    /* The pie chart. */
    vis.add(pv.Wedge)
    .data(normalized_data)
    .bottom((height / 2)+25)
    .left(width / 2)
    .innerRadius(0)
    .outerRadius(radius)
    .fillStyle(function() {return pieColors[this.index]})
    .angle(function(d) {return d * 2 * Math.PI});

    /* Labels. */
    vis.add(pv.Wedge)
    .data([1])
    .bottom(36)
    .left(10)
    .innerRadius(0)
    .outerRadius(5)
    .fillStyle(function() {return pieColors[0]})
    .angle(function(d) {return d * 2 * Math.PI});

    
    vis.add(pv.Label)
    .left(25)
    .bottom(28)
    .textAlign("left")
    .textStyle(axesLabelColor)
    .font("14px sans-serif")
    .text("Process Usage "+percentage_data[0]+"%");

    vis.add(pv.Wedge)
    .data([1])
    .bottom(8)
    .left(10)
    .innerRadius(0)
    .outerRadius(5)
    .fillStyle(function() {return pieColors[1]})
    .angle(function(d) {return d * 2 * Math.PI});
    
    /* Labels. */
    vis.add(pv.Label)
    .left(25)
    .bottom(0)
    .textAlign("left")
    .textStyle(axesLabelColor)
    .font("14px sans-serif")
    .text("Idle Usage "+percentage_data[1]+"%");

    vis.render();
}

function renderMachineEnergyChart(data, duration)
{
    /* Sizing and scales. */
    var width = 850,
    height = 200,
    interval = duration / data.length,
    ymax = pv.max(data, function(d) {return d}),
    yScale = pv.Scale.linear(0, ymax).range(0, height),
    xScale = pv.Scale.linear(0, duration).range(10, width);


    /* The root panel. */
    var vis = new pv.Panel()
    .width(width)
    .height(height)
    .top(10)
    .bottom(40)
    .left(45)
    .right(0);

    /* X-axis ticks. */
    vis.add(pv.Rule)
    .data(xScale.ticks())
    .visible(function(d){
        return d > 0
    })
    .left(xScale)
    .strokeStyle(axisColor)
    .width(0)
    .add(pv.Rule)
    .bottom(-5)
    .height(5)
    .strokeStyle(axisColor)
    .anchor("bottom").add(pv.Label)
    .textStyle(axesLabelColor)
    .text(xScale.tickFormat);

    /* Y-axis ticks. */
    vis.add(pv.Rule)
    .data(yScale.ticks(5))
    .bottom(yScale)
    .strokeStyle(axisColor)
    .anchor("left").add(pv.Label)
    .textStyle(axesLabelColor)
    .text(yScale.tickFormat);

    /* The line. */
    vis.add(pv.Line)
    .data(data)
    .interpolate("step-after")
    .left(function(d){
        return xScale(this.index * interval)
    })
    .bottom(function(d){
        return yScale(d)
    })
    .strokeStyle(lineColor)
    .lineWidth(1);

    /* Y-axis label. */
    vis.add(pv.Label)
    .right(0)
    .top(240)
    .textAlign("right")
    .textStyle(axesLabelColor)
    .font(axesLabelFont)
    .text("Time (sec)");

    /* X-axis label. */
    vis.add(pv.Label)
    .left(-25)
    .top(10)
    .textAlign("right")
    .textStyle(axesLabelColor)
    .textAngle(4.712)
    .font(axesLabelFont)
    .text("Watts");

    vis.render();
}