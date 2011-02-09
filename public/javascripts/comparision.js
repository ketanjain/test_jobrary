// If the base analysis has to be removed from comparision then restore original data for other analysis.
function removeFromComparision(id)
{
    if($('analysis_'+id).hasClassName('active'))
    {
        restoreOriginalData()
    }
}

// Restore original data for all the analysis.
function restoreOriginalData()
{
    var comElements = [], originalElements = [],comId;
    $('comparision_table').childElements().each(function(item) {
        if(!($(item).id.include('select_analysis_')))
        {
            comId = $(item).id.gsub('analysis_','');
            comElements = $('comparision_data_'+comId).childElements();
            originalElements = $('comparision_original_data_'+comId).childElements();
            for(var i =0; i< comElements.length ; i++)
            {
                comElements[i].removeClassName('red')
                comElements[i].removeClassName('green')
                comElements[i].innerHTML = originalElements[i].innerHTML
            }
        }
    })
}

// Redo base calculations for all the analysis based on current base analysis.
function resetExistingBase()
{
    var id;
    $$('#comparision_table div.active').each(function(item) {
        id = $(item).id.gsub('analysis_','');
        setAsBase(id,true)
    })
}

// Calculate the data for all analysis based on base analysis.
function setAsBase(id,isReset)
{
    var comElements = [], selectedBaseElements = [],comId;

    restoreOriginalData();

    if($('analysis_'+id).hasClassName("active") && !isReset)
        {
            $('analysis_'+id).removeClassName("active")
            return;
        }

    selectedBaseElements = $('comparision_data_'+id).childElements();
    $('comparision_table').childElements().each(function(item) {
        if(!($(item).id.include('select_analysis_')))
        {
            $(item).removeClassName("active")
            comId = $(item).id.gsub('analysis_','');
            comElements = $('comparision_data_'+comId).childElements()
            for(var i =0; i< comElements.length ; i++)
            {
                if(comId != id)
                {
                    comElements[i].innerHTML = (parseFloat(comElements[i].innerHTML) - parseFloat(selectedBaseElements[i].innerHTML)).toFixed(3)
                    if(parseFloat(comElements[i].innerHTML) < 0)
                    {
                        comElements[i].addClassName('red')
                    }
                    else if(parseFloat(comElements[i].innerHTML) > 0)
                    {
                        comElements[i].addClassName('green')
                    }
                }
            }
        }
    })
    $('analysis_'+id).addClassName("active");
}