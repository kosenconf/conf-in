class ApplicationController < ActionController::Base
  $select_form = [
    { question: :select1, content: :select_content1,
      setting: :select_setting1 },
    { question: :select2, content: :select_content2,
      setting: :select_setting2 },
    { question: :select3, content: :select_content3,
      setting: :select_setting3 },
    { question: :select4, content: :select_content4,
      setting: :select_setting4 },
    { question: :select5, content: :select_content5,
      setting: :select_setting5 }
  ]
  $free_form = [
    { question: :free1, setting: :free_setting1 },
    { question: :free2, setting: :free_setting2 },
    { question: :free3, setting: :free_setting3 },
    { question: :free4, setting: :free_setting4 },
    { question: :free5, setting: :free_setting5 }
  ]
  
  protect_from_forgery
end
