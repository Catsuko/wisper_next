RSpec.describe WisperNext::Subscriber::ResolveMethod do
  subject { described_class }

  describe '#call' do
    describe 'when name is underscoreable' do
      it 'returns underscored String' do
        name = Class.new(String) do
          def underscore
            'my_event'
          end
        end.new('MyEvent')

        expect(subject.call(name, false)).to eq(name.underscore)
      end
    end

    describe 'when name is not underscoreable' do
      it 'returns String' do
        name = 'MyEvent'
        expect(subject.call(name, false)).to eq(name)
      end
    end

    describe 'when prefix is true' do
      it 'returns name with "on_" prefix' do
        expect(subject.call("MyEvent", true)).to start_with('on_')
      end
    end

    describe 'when prefix is false' do
      it 'returns name without "on_" prefix' do
        expect(subject.call("MyEvent", false)).not_to start_with('on_')
      end
    end
  end
end
