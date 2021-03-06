# == Schema Information
#
# Table name: readings
#
#  id             :integer          not null, primary key
#  depth          :float
#  units_depth    :string
#  salinity       :integer
#  units_salinity :string
#  description    :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  approved       :boolean
#  latitude       :float
#  longitude      :float
#  deleted_at     :datetime
#
# Indexes
#
#  index_readings_on_approved    (approved)
#  index_readings_on_deleted_at  (deleted_at)
#

require 'rails_helper'

RSpec.describe Reading, type: :model do
  before do
    @r1 = (1...10).map { create(:reading) }.first
  end

  it 'soft deletes the reading' do
    expect(@r1.deleted?).not_to eq(true)
    expect(Reading.count).to eq(Reading.with_deleted.count)
    expect(Reading.pending.count).to eq(Reading.with_deleted.count)
    expect(Reading.approved.count).to eq(0)

    expect {
      @r1.destroy
      expect(@r1.deleted?).to eq(true)
    }.to change { Reading.count }.by(-1)
     .and change { Reading.with_deleted.count }.by(0)
     .and change { Reading.pending.count }.by(-1)
     .and change { Reading.approved.count }.by(0)
     .and change { Reading.with_deleted.find(@r1.id).deleted? }.from(false).to(true)

    expect {
      @r1.destroy
      expect(@r1.deleted?).to eq(true)
    }.to change { Reading.count }.by(0)
     .and change { Reading.with_deleted.count }.by(0)
     .and change { Reading.pending.count }.by(0)
     .and change { Reading.approved.count }.by(0)
    expect(Reading.with_deleted.find(@r1.id).deleted?).to eq(true)
  end

  it 'approves the reading' do
    expect(@r1.approved?).not_to eq(true)
    expect(Reading.count).to eq(Reading.with_deleted.count)
    expect(Reading.pending.count).to eq(Reading.with_deleted.count)
    expect(Reading.approved.count).to eq(0)

    expect {
      @r1.approve!
      expect(@r1.approved?).to eq(true)
    }.to change { Reading.count }.by(0)
     .and change { Reading.with_deleted.count }.by(0)
     .and change { Reading.pending.count }.by(-1)
     .and change { Reading.approved.count }.by(1)
     .and change { Reading.find(@r1.id).approved? }.to(true)
    expect(Reading.find(@r1.id).approved?).to eq(true)

    expect {
      @r1.approve!
      expect(@r1.approved?).to eq(true)
    }.to change { Reading.count }.by(0)
     .and change { Reading.with_deleted.count }.by(0)
     .and change { Reading.pending.count }.by(0)
     .and change { Reading.approved.count }.by(0)
    expect(Reading.find(@r1.id).approved?).to eq(true)
  end
end
