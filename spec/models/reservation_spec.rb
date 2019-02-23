require 'rails_helper'

RSpec.describe Reservation, type: :model do
  Restaurant.create(name: 'test', open_time: '08:00', close_time: '20:00')
  Table.create(number: 1, restaurant_id: 1)
  User.create(name: 'user')
  context 'Check custom validator validate_restaurant_schedule' do
    it 'Check errors outside open time' do
      answer = described_class.new(start_time: '07:30'.to_time, end_time: '09:00'.to_time, table_id: 1, user_id: 1)
      answer.valid?

      expect(answer.errors.full_messages).to include('outside_work_schedule')
    end

    it 'Check errors inside open time' do
      answer = described_class.new(start_time: '08:00'.to_time, end_time: '09:00'.to_time, table_id: 1, user_id: 1)
      answer.valid?

      expect(answer.errors.full_messages).not_to include('outside_work_schedule')
    end

    it 'Check errors outside close time' do
      answer = described_class.new(start_time: '19:30'.to_time, end_time: '20:30'.to_time, table_id: 1, user_id: 1)
      answer.valid?

      expect(answer.errors.full_messages).to include('outside_work_schedule')
    end

    it 'Check errors inside close time' do
      answer = described_class.new(start_time: '19:00'.to_time, end_time: '20:00'.to_time, table_id: 1, user_id: 1)
      answer.valid?

      expect(answer.errors.full_messages).not_to include('outside_work_schedule')
    end
  end
end
