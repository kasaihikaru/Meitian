Rails.application.routes.draw do
  devise_for :users, :controllers => {
      registrations: "users/registrations",
      confirmations: "users/confirmations",
      sessions: "users/sessions",
      passwords: "users/passwords",
  }

  root to: "homes#show"

  resource :home, only: [:show]
  resource :me, only: [:show]


  resources :users, only: [:show] do
    get 'passages' #ユーザーの長文一覧
    get 'papers' #ユーザーの短文集一覧
    get 'rings' #ユーザーの単語帳一覧
  end

  resources :passages, only: [:new, :edit, :create, :update, :destroy, :show, :index] do
    #get
    get 'word_ja' #単語を日本語から暗記
    get 'word_ch' #単語を中国語から暗記

    #post, put
    post 'copy' #長文コピー
    put 'uncheck_all_words_ja' #単語覚えたチェック全部取り消し（日本語）
    put 'uncheck_all_words_ch' #単語覚えたチェック全部取り消し（中国語）
    put 'waiting' #ステータスを未着手に
    put 'working' #ステータスを勉強中に
    put 'review_needed' #ステータスを要復習に
    put 'completed' #ステータスを完了！に
  end

  resources :sample_passages, only: [:show] do
    post 'copy' #HSK教材をマイ教材にコピー
  end

  resources :p_words, only: [:edit, :update, :destroy] do
    #get
    get 'edit_pin' #ピンイン編集ページ

    #post, put
    put 'check_ja' #覚えたチェック
    put 'check_ch' #覚えたチェック
    put 'uncheck_ja' #覚えたチェック取り消し
    put 'uncheck_ch' #覚えたチェック取り消し
    put 'update_pin' #ピンインを更新
  end

  resources :papers, only: [:edit, :create, :update, :destroy, :show, :index] do
    #get
    get 'sentence_ja' #短文を日本語から暗記
    get 'sentence_ch' #短文を中国語から暗記
    get 'word_ja' #単語を日本語から暗記
    get 'word_ch' #単語を中国語から暗記

    #post, put
    post 'copy' #短文帳コピー
    put 'uncheck_all_sentences_ja' #短文覚えたチェック全部取り消し（日本語）
    put 'uncheck_all_sentences_ch' #短文覚えたチェック全部取り消し（中国語）
    put 'uncheck_all_words_ja' #単語覚えたチェック全部取り消し（日本語）
    put 'uncheck_all_words_ch' #単語覚えたチェック全部取り消し（中国語）
    put 'waiting' #ステータスを未着手に
    put 'working' #ステータスを勉強中に
    put 'review_needed' #ステータスを要復習に
    put 'completed' #ステータスを完了！に
  end

  resources :sentences, only: [:new, :edit, :create, :update, :destroy] do
    #get
    get 'edit_pin' #ピンイン編集ページ

    #post, put
    post 'copy' #短文コピー
    put 'check_ja' #覚えたチェック
    put 'check_ch' #覚えたチェック
    put 'uncheck_ja' #覚えたチェック取り消し
    put 'uncheck_ch' #覚えたチェック取り消し
    put 'update_pin' #ピンインを更新
  end

  resources :s_words, only: [:edit, :create, :update, :destroy] do
    #get
    get 'edit_pin' #ピンイン編集ページ

    #post, put
    put 'check_ja' #覚えたチェック
    put 'check_ch' #覚えたチェック
    put 'uncheck_ja' #覚えたチェック取り消し
    put 'uncheck_ch' #覚えたチェック取り消し
    put 'update_pin' #ピンインを更新
  end


  resources :rings, only: [:edit, :create, :update, :destroy, :show] do
    #get
    get 'word_ja' #単語を日本語から暗記
    get 'word_ch' #単語を中国語から暗記

    #post, put
    post 'copy' #単語帳コピー
    put 'uncheck_all_words_ja' #単語覚えたチェック全部取り消し（日本語）
    put 'uncheck_all_words_ch' #単語覚えたチェック全部取り消し（中国語）
    put 'waiting' #ステータスを未着手に
    put 'working' #ステータスを勉強中に
    put 'review_needed' #ステータスを要復習に
    put 'completed' #ステータスを完了！に
  end

  resources :r_words, only: [:new, :edit, :create, :update, :destroy] do
    #get
    get 'edit_pin' #ピンイン編集ページ

    #post, put
    post 'copy' #単語コピー
    put 'check_ja' #覚えたチェック
    put 'check_ch' #覚えたチェック
    put 'uncheck_ja' #覚えたチェック取り消し
    put 'uncheck_ch' #覚えたチェック取り消し
    put 'update_pin' #ピンインを更新
  end

  resource :docs, only: [] do
    get 'term' #利用規約
    get 'privacy' #プライバシポリシー
    get 'hsk_index' #hsk単語帳一覧
  end

end
