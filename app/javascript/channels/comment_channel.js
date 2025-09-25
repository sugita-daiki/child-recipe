import consumer from "channels/consumer"

if(location.pathname.match(/\/recipes\/\d/)){
  
consumer.subscriptions.create({
    channel: "CommentChannel",
    recipe_id: location.pathname.match(/\d+/)[0]
  }, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
      const now = new Date();
      const timeString = now.getFullYear() + '年' + 
                        String(now.getMonth() + 1).padStart(2, '0') + '月' + 
                        String(now.getDate()).padStart(2, '0') + '日 ' + 
                        String(now.getHours()).padStart(2, '0') + ':' + 
                        String(now.getMinutes()).padStart(2, '0');
      
      const html = `
        <div class="comment">
          <p class="comment-author">${data.user.nickname}</p>
          <p class="comment-content">${data.comment.content}</p>
          <p class="comment-date">${timeString}</p>
        </div>`
      const commentsList = document.getElementById("comments-list")
      if (commentsList) {
        commentsList.insertAdjacentHTML('afterbegin', html)
      }
      const commentForm = document.getElementById("comment-form")
      if (commentForm) {
        commentForm.reset();
      }
  }
})

// コメントフォームのエラーハンドリング
document.addEventListener('DOMContentLoaded', function() {
  const commentForm = document.getElementById('comment-form');
  if (commentForm) {
    commentForm.addEventListener('ajax:error', function(event) {
      const [data, status, xhr] = event.detail;
      console.error('コメント投稿エラー:', data);
      alert('コメントの投稿に失敗しました。もう一度お試しください。');
    });
    
    commentForm.addEventListener('ajax:success', function(event) {
      const [data, status, xhr] = event.detail;
      if (data.status === 'error') {
        alert('エラー: ' + data.errors.join(', '));
      }
    });
  }
});
}