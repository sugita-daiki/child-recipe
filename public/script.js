// モーダル表示・非表示の関数
function showLoginModal() {
    document.getElementById('loginModal').style.display = 'block';
}

function showRegisterModal() {
    document.getElementById('registerModal').style.display = 'block';
}

function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
}

// モーダル外クリックで閉じる
window.onclick = function(event) {
    const modals = document.querySelectorAll('.modal');
    modals.forEach(modal => {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });
}

// ログイン機能（ダミー）
function login() {
    const email = document.getElementById('loginEmail').value;
    const password = document.getElementById('loginPassword').value;
    
    if (email && password) {
        // ダミーのログイン処理
        alert('ログインしました！');
        
        // ユーザー情報を表示
        document.getElementById('userInfo').style.display = 'flex';
        document.querySelector('.nav-buttons').style.display = 'none';
        
        // モーダルを閉じる
        closeModal('loginModal');
        
        // フォームをリセット
        document.getElementById('loginEmail').value = '';
        document.getElementById('loginPassword').value = '';
    } else {
        alert('メールアドレスとパスワードを入力してください。');
    }
}

// 新規登録機能（ダミー）
function register() {
    const nickname = document.getElementById('registerNickname').value;
    const email = document.getElementById('registerEmail').value;
    const password = document.getElementById('registerPassword').value;
    const profile = document.getElementById('registerProfile').value;
    
    if (nickname && email && password) {
        // ダミーの登録処理
        alert('新規登録が完了しました！');
        
        // ユーザー情報を表示
        document.querySelector('.user-name').textContent = nickname + 'さん';
        document.getElementById('userInfo').style.display = 'flex';
        document.querySelector('.nav-buttons').style.display = 'none';
        
        // モーダルを閉じる
        closeModal('registerModal');
        
        // フォームをリセット
        document.getElementById('registerNickname').value = '';
        document.getElementById('registerEmail').value = '';
        document.getElementById('registerPassword').value = '';
        document.getElementById('registerProfile').value = '';
    } else {
        alert('ニックネーム、メールアドレス、パスワードは必須項目です。');
    }
}

// ログアウト機能
function logout() {
    document.getElementById('userInfo').style.display = 'none';
    document.querySelector('.nav-buttons').style.display = 'flex';
    alert('ログアウトしました。');
}

// レシピ詳細表示機能（ダミー）
function showRecipeDetail(recipeId) {
    const recipeData = {
        1: {
            title: '簡単！にんじんの甘煮',
            author: 'ママ太郎',
            image: 'https://via.placeholder.com/400x300/FFB6C1/FFFFFF?text=にんじんの甘煮',
            description: '子供が喜ぶ甘い味付けで、にんじん嫌いも克服！',
            ingredients: '【材料】\n・にんじん 1本\n・砂糖 大さじ2\n・醤油 小さじ1\n・水 100ml',
            instructions: '【作り方】\n1. にんじんを薄くスライスする\n2. 鍋に材料を全て入れて中火で煮る\n3. にんじんが柔らかくなったら完成！',
            likes: 12,
            comments: 3
        },
        2: {
            title: 'ふわふわ卵焼き',
            author: 'パパ花子',
            image: 'https://via.placeholder.com/400x300/87CEEB/FFFFFF?text=ふわふわ卵焼き',
            description: '砂糖を入れて甘く仕上げた、子供が大好きな卵焼き',
            ingredients: '【材料】\n・卵 3個\n・砂糖 大さじ1\n・塩 少々\n・サラダ油 適量',
            instructions: '【作り方】\n1. 卵を溶いて砂糖と塩を加える\n2. フライパンに油を熱する\n3. 卵液を流し入れて弱火で焼く\n4. 半熟の状態で巻いて完成！',
            likes: 8,
            comments: 2
        },
        3: {
            title: '孫が大好き！肉じゃが',
            author: 'おばあちゃん',
            image: 'https://via.placeholder.com/400x300/FFE4B5/FFFFFF?text=孫が大好き肉じゃが',
            description: '優しい味付けで孫も喜ぶ、定番の肉じゃが',
            ingredients: '【材料】\n・じゃがいも 3個\n・にんじん 1本\n・玉ねぎ 1個\n・牛肉 200g\n・醤油 大さじ3\n・砂糖 大さじ2\n・みりん 大さじ2',
            instructions: '【作り方】\n1. 野菜を一口大に切る\n2. 肉を炒めて野菜を加える\n3. 調味料を加えて煮込む\n4. 野菜が柔らかくなったら完成！',
            likes: 15,
            comments: 5
        },
        4: {
            title: '野菜たっぷりハンバーグ',
            author: 'ママ太郎',
            image: 'https://via.placeholder.com/400x300/DDA0DD/FFFFFF?text=野菜たっぷりハンバーグ',
            description: '野菜を細かく刻んで混ぜ込んだ、栄養満点ハンバーグ',
            ingredients: '【材料】\n・合挽き肉 300g\n・玉ねぎ 1/2個\n・にんじん 1/2本\n・パン粉 大さじ3\n・卵 1個\n・塩コショウ 少々',
            instructions: '【作り方】\n1. 野菜を細かく刻む\n2. 肉と野菜、調味料を混ぜる\n3. ハンバーグの形に成形\n4. フライパンで両面焼く',
            likes: 20,
            comments: 7
        }
    };
    
    const recipe = recipeData[recipeId];
    if (recipe) {
        const content = `
            <div class="recipe-detail">
                <div class="recipe-detail-header">
                    <h2>${recipe.title}</h2>
                    <p class="recipe-detail-author">投稿者: ${recipe.author}</p>
                </div>
                <div class="recipe-detail-image">
                    <img src="${recipe.image}" alt="${recipe.title}">
                </div>
                <div class="recipe-detail-content">
                    <p class="recipe-detail-description">${recipe.description}</p>
                    <div class="recipe-detail-ingredients">
                        <h3>材料</h3>
                        <pre>${recipe.ingredients}</pre>
                    </div>
                    <div class="recipe-detail-instructions">
                        <h3>作り方</h3>
                        <pre>${recipe.instructions}</pre>
                    </div>
                    <div class="recipe-detail-stats">
                        <span class="likes">❤️ ${recipe.likes}</span>
                        <span class="comments">💬 ${recipe.comments}</span>
                    </div>
                    <div class="recipe-detail-actions">
                        <button class="btn btn-primary" onclick="likeRecipe(${recipeId})">いいね</button>
                        <button class="btn btn-secondary" onclick="addComment(${recipeId})">コメント</button>
                    </div>
                </div>
            </div>
        `;
        
        document.getElementById('recipeDetailContent').innerHTML = content;
        document.getElementById('recipeDetailModal').style.display = 'block';
    }
}

// いいね機能（ダミー）
function likeRecipe(recipeId) {
    alert('いいねしました！');
}

// コメント機能（ダミー）
function addComment(recipeId) {
    const comment = prompt('コメントを入力してください:');
    if (comment) {
        alert('コメントを投稿しました！');
    }
}

// ページ読み込み時の初期化
document.addEventListener('DOMContentLoaded', function() {
    // アニメーション効果
    const cards = document.querySelectorAll('.recipe-card');
    cards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
    
    // スムーススクロール
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth'
                });
            }
        });
    });
});
