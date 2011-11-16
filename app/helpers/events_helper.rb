# coding: utf-8
module EventsHelper
  # フォームのURL
  def form_url
    if params[:action] == 'edit' 
      return { action: :update, id: @event.id, admin_token: @event.admin_token }
    else
      return { action: :create }
    end
  end
  
  # イベント削除リンク
  def link_to_destroy_event(label='このイベントを削除する',
    html_options={}
    )
    link_to_if current_user && @event.owner_user_id == current_user.id,
    label, event_path(@event),
    {
      method: :delete, 
      confirm: "本当に削除しますか？（ユーザからの参加登録も同時に削除されます）"
    }.merge!(html_options)
  end
  
  def link_to_edit_event(label='このイベントを編集する', html_options={})
    link_to label, edit_event_path(@event, admin_token: @event.admin_token),
    html_options
  end
end
