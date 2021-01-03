class HomesController < ApplicationController
  def show
    @passages = Passage.active.not_sapmle.recent
    @papers = Paper.active.not_sapmle.recent
    @rings = Ring.active.not_sapmle.recent
    @hsk_passages = SamplePassage.hsk.active.four
  end
end
