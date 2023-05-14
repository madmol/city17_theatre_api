require 'rails_helper'

RSpec.describe Play, type: :model do
  describe 'validations' do
    subject { build(:play) }

    let(:blank_error_message) { I18n.t('activerecord.errors.messages.blank') }
    let(:invalid_date_range_error_message) { I18n.t('activerecord.errors.models.play.attributes.date_range.invalid_date_range') }
    let(:invalid_date_range_type_error_message) { -> (value) { I18n.t('activerecord.errors.models.play.attributes.date_range.invalid_type', value_class: value.class) }}
    let(:overlaps_with_other_error_message) { I18n.t('activerecord.errors.models.play.attributes.date_range.overlaps_with_other') }
    let(:start_date) { Date.today }
    let(:end_date) { Date.today + 3.days }


    it { is_expected.to validate_presence_of(:title) }

    it 'is invalid if the start date is after the end date' do
      subject.date_range = Date.today...(Date.today - 1.day)
      expect(subject).not_to be_valid
      expect(subject.errors[:date_range]).to include(invalid_date_range_error_message)
    end

    it 'is invalid if the date range is not a range' do
      invalid_value = 'invalid date range'
      expect { subject.date_range = invalid_value }.to raise_error(ArgumentError, invalid_date_range_type_error_message.call(invalid_value))
    end

    it 'is invalid if the date range is missing' do
      invalid_value = nil
      expect { subject.date_range = invalid_value }.to raise_error(ArgumentError, invalid_date_range_type_error_message.call(invalid_value))
    end

    it 'is valid if the date range does not overlap with another play' do
      play1 = create(:play, date_range: Date.today..(Date.today + 3.days))
      play2 = build(:play, date_range: (Date.today + 4.days)..(Date.today + 4.days))
      expect(play2).to be_valid
    end

    context 'when date range overlaps with other play' do
      let!(:play1) { create(:play, date_range: start_date..end_date) }

      it 'is invalid if the date range overlaps with another play if start_date is equal to end_date previous play' do
        play2 = build(:play, date_range: end_date..(end_date + 3.days))
        expect(play2).not_to be_valid
        expect(play2.errors[:date_range]).to include(overlaps_with_other_error_message)
      end

      it 'is invalid if the date range overlaps with another play if end_date is equal to start_date previous play' do
        play2 = build(:play, date_range: (start_date - 3.days)..start_date)
        expect(play2).not_to be_valid
        expect(play2.errors[:date_range]).to include(overlaps_with_other_error_message)
      end

      it 'is invalid if the date range overlaps with another play if range_date is inside date_range previous play' do
        play2 = build(:play, date_range: (start_date + 1.day)..(end_date - 1.day))
        expect(play2).not_to be_valid
        expect(play2.errors[:date_range]).to include(overlaps_with_other_error_message)
      end

      it 'is invalid if the date range overlaps with another play if start_date is inside date_range previous play' do
        play2 = build(:play, date_range: (start_date + 1.day)..(end_date + 10.days))
        expect(play2).not_to be_valid
        expect(play2.errors[:date_range]).to include(overlaps_with_other_error_message)
      end

      it 'is invalid if the date range overlaps with another play if end_date is inside date_range previous play' do
        play2 = build(:play, date_range: (start_date - 4.days)..(start_date + 1.day))
        expect(play2).not_to be_valid
        expect(play2.errors[:date_range]).to include(overlaps_with_other_error_message)
      end

      it 'is invalid if the date range overlaps with another play if satrt and end dates is outside the previous play range' do
        play2 = build(:play, date_range: (start_date - 4.days)..(end_date + 10.day))
        expect(play2).not_to be_valid
        expect(play2.errors[:date_range]).to include(overlaps_with_other_error_message)
      end
    end
  end
end
