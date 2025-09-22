## データベース設計

### Users テーブル
| Column             | Type    | Options                  |
|--------------------|---------|--------------------------|
| nickname           | string  | null:false               |
| email              | string  | null: false, unique: true|
| encrypted_password | string  | null: false              |
| profile            | text    |                          |

- has_many :recipes  
- has_many :comments  
- has_many :likes  


### Recipes テーブル
| Column     | Type       | Options                        |
|------------|------------|--------------------------------|
| title      | string     | null: false                   |
| description| text       | null: false                   |
| user_id    | references | null: false, foreign_key: true |

- belongs_to :user  
- has_many :comments  
- has_many :likes  



### Comments テーブル
| Column   | Type       | Options                        |
|----------|------------|--------------------------------|
| content  | text       | null: false                   |
| user_id  | references | null: false, foreign_key: true |
| recipe_id| references | null: false, foreign_key: true |

- belongs_to :user  
- belongs_to :recipe  



### Likes テーブル（中間テーブル）
| Column   | Type       | Options                        |
|----------|------------|--------------------------------|
| user_id  | references | null: false, foreign_key: true |
| recipe_id| references | null: false, foreign_key: true |

- belongs_to :user  
- belongs_to :recipe  


### Tags テーブル
| Column | Type   | Options     |
|--------|--------|-------------|
| name   | string | null: false, unique: true |

- has_many :recipe_tags  
- has_many :recipes, through: :recipe_tags  

---

### RecipeTags テーブル（中間テーブル）
| Column    | Type       | Options                        |
|-----------|------------|--------------------------------|
| recipe_id | references | null: false, foreign_key: true |
| tag_id    | references | null: false, foreign_key: true |

- belongs_to :recipe  
- belongs_to :tag  