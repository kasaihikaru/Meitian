class RingsController < ApplicationController
  before_action :login_check, except: [:word_ja, :word_ch, :show]
  before_action -> {
    user_check_by_id(get_user_by_ring_id_for_ring)
  },only: [:uncheck_all_words_ja, :uncheck_all_words_ch, :waiting, :working, :review_needed, :completed]
  before_action -> {
    user_check_by_id(get_user_by_id_for_ring)
  },only: [:edit, :update, :destroy]

  #-----------------------get-----------------------
  def show
    @ring = Ring.find(id_params)
    @user = @ring.user
    @words = @ring.r_words.active
    @all_count = @words.count
    @memorized_count_ch = @words.memorized_ja.count
    @memorized_count_ja = @words.memorized_ch.count
    get_progresses
  end

  def edit
    @ring = Ring.find(id_params)
  end

  def get_for_ring_show
    @ring = Ring.find(ring_id_params)
    @user = @ring.user
    @words = @ring.r_words.active
    @all_count = @words.count
  end

  def word_ja
    get_for_ring_show
    @memorized_count = @words.memorized_ja.count
    get_progress
  end

  def word_ch
    get_for_ring_show
    @memorized_count = @words.memorized_ch.count
    get_progress
  end

  #-----------------------post, put-----------------------
  def create
    ring = Ring.create(create_params)
    @myrings = current_user.rings.active
    redirect_to new_r_word_path(ring_id: ring.id)
  end

  def update
    @ring = Ring.find(id_params)
    @ring.update(update_params)

    add_new_words_params.each do |w|
      if w[:ja].present? && w[:ch].present?
        pinyin = get_pinyin(w[:ch])
        RWord.create(ja: w[:ja], ch: w[:ch], ring_id: @ring.id, pin: pinyin)
      end
    end

    redirect_to ring_word_ch_path(@ring)
  end

  def destroy
    ring = Ring.find(id_params)
    ring.update(deleted_at: Time.now)
    ring.r_words.each do |word|
      word.update(deleted_at: Time.now)
    end

    redirect_to user_rings_path(current_user)
  end

  def copy
    ring_id = Ring.find(ring_id_params).id
    user_id = current_user.id
    copy_specific_ring(ring_id, user_id, false)
    @msg = "マイ教材として保存しました。"
  end

  def uncheck_all_words_ja
    ring = Ring.find(ring_id_params)
    ring.r_words.each do |word|
      word.update(memorized_ja: 0)
    end

    redirect_to ring_word_ja_path(ring, anchor: 'ring-words-ja')
  end

  def uncheck_all_words_ch
    ring = Ring.find(ring_id_params)
    ring.r_words.each do |word|
      word.update(memorized_ch: 0)
    end

    redirect_to ring_word_ch_path(ring, anchor: 'ring-words-ch')
  end

  def waiting
    @ring = Ring.find(ring_id_params)
    @ring.waiting!
  end

  def working
    @ring = Ring.find(ring_id_params)
    @ring.working!
  end

  def review_needed
    @ring = Ring.find(ring_id_params)
    @ring.review_needed!
  end

  def completed
    @ring = Ring.find(ring_id_params)
    @ring.completed!
  end

private
  def create_params
    params.require(:ring).permit(:name).merge(user_id: current_user.id, modified_at: Time.now, status: 10)
  end

  def update_params
    params.require(:ring).permit(:name, r_words_attributes: [:ja, :ch, :_destroy, :id]).merge(modified_at: Time.now)
  end

end
