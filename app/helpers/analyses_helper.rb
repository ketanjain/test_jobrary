module AnalysesHelper

  def trimDescription(desc)
    if desc.length > 70
      desc = desc[0,70]
      desc = desc[0,desc.rindex(" ")]
      return desc + "..."
    else
      return desc
    end

  end
end
