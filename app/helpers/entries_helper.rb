# coding: utf-8
module EntriesHelper
  def que_survey(state, question)
    unless state == 0
      "<th class='indexTable'>#{h(question)}</th>"
    end
  end
  
  def ans_survey(state, ans)
    unless state == 0
      "<td class='indexTable'>#{h(ans)}</td>"
    end
  end
end
