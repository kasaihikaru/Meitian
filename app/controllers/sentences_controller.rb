class SentencesController < ApplicationController
  before_action :login_check
  before_action -> {
    user_check_by_id(get_user_by_sentence_id_for_sentence)
  },only: [:edit_pin, :update_pin, :check_ja, :check_ch, :uncheck_ja, :uncheck_ch]
  before_action -> {
    user_check_by_id(get_user_by_id_for_sentence)
  },only: [:edit, :update, :destroy]

  #-----------------------get-----------------------
  def new
    @sentence = Sentence.new
    @sentence.s_words.build
    @mypapers = current_user.papers.active
    @new_paper = Paper.new
    @paper_id = params[:paper_id]
  end

  def edit
    @sentence = Sentence.find(id_params)
    @redirect_flg = params[:redirect_flg]
  end

  def edit_pin
    @sentence = Sentence.find(sentence_id_params)
    @redirect_flg = params[:redirect_flg]
  end

  #-----------------------post, put-----------------------
  def create
    # 短文作成
    sentence = Sentence.create(create_sentence_params)

    # 付属の単語作成
    words = words_attribute_params(sentence.id)
    words.each do |w|
        SWord.create("ja"=>w[:ja], "ch"=>w[:ch], "pin"=>w[:pin], "sentence_id"=>w[:sentence_id])
    end

    # paperを最新化
    sentence.paper.update(modified_at: Time.now)

    #リダイレクト
    redirect_to paper_path(sentence.paper.id)
  end

  def update
    # 長文更新
    sentence = Sentence.find(id_params)
    sentence.update(ja:create_sentence_params[:ja], ch:create_sentence_params[:ch], pin:create_sentence_params[:pin])

    #paper更新
    paper = sentence.paper
    paper.update(modified_at: Time.now)

    # 単語更新
    words = words_attribute_params(sentence.id)
    words.each do |w|
      original_word = SWord.find(w[:id])
      if original_word.pin_fixed == true
        original_word.update(ja: w[:ja], ch: w[:ch])
      else
        original_word.update(ja: w[:ja], ch: w[:ch], pin: w[:pin])
      end
    end

    # 新規word追加
    add_new_words_params.each do |w|
      if w[:ja].present? && w[:ch].present?
        pinyin = get_pinyin(w[:ch])
        SWord.create(ja: w[:ja], ch: w[:ch], sentence_id: sentence.id, pin: pinyin)
      end
    end

    #リダイレクト
    if params[:sentence][:redirect_flg] == "sentence_ja"
      redirect_to paper_sentence_ja_path(paper.id)
    else
      redirect_to paper_path(paper.id)
    end
  end

  def update_pin
    sentence = Sentence.find(sentence_id_params)
    if sentence.pin != pin_params
      sentence.update(pin: pin_params, pin_fixed: 1)
    end

    #リダイレクト
    if params[:redirect_flg] == "sentence_ja"
      redirect_to paper_sentence_ja_path(sentence.paper.id)
    else
      redirect_to paper_path(sentence.paper.id)
    end
  end

  def destroy
  end

  def copy
  end

  def get_for_check
    @sentence = Sentence.find(sentence_id_params)
    @sentences = @sentence.paper.sentences.active
    @all_sentence_count = @sentences.count
  end

  def check_ja
    get_for_check
    @sentence.update( memorized_ja: 1 )
    @memorized_sentence_count_ja = @sentences.memorized_ja.count
    get_progress_sentence_ja
  end

  def check_ch
    get_for_check
    @sentence.update( memorized_ch: 1 )
    @memorized_sentence_count_ch = @sentences.memorized_ch.count
    get_progress_sentence_ch
  end

  def uncheck_ja
    get_for_check
    @sentence.update( memorized_ja: 0 )
    @memorized_sentence_count_ja = @sentences.memorized_ja.count
    get_progress_sentence_ja
  end

  def uncheck_ch
    get_for_check
    @sentence.update( memorized_ch: 0 )
    @memorized_sentence_count_ch = @sentences.memorized_ch.count
    get_progress_sentence_ch
  end


  private
  #-----------------------ストロングパラメーター-----------------------
  def create_sentence_params
      pinyin = get_pinyin(params[:sentence][:ch])
      params.require(:sentence).permit(:paper_id, :ja, :ch).merge(pin: pinyin)
  end
  def words_attribute_params(sentence_id)
    array = []
    words = params[:sentence][:s_words_attributes]
    if words.present?
      words.each do |key,value|
        if value["ja"].present? && value["ch"].present?
          value[:sentence_id] = sentence_id
          value[:pin] = get_pinyin(value[:ch])
          value[:id] = key.to_i
          array << value
        else
          next
        end
      end
    end
    return array
  end

  def update_sentence_params
      pinyin = get_pinyin(params[:sentence][:ch])
      params.require(:sentence).permit(:ja, :ch).merge(pin: pinyin)
  end
  def update_new_words_params
      params.require(:new_words)
  end
end
