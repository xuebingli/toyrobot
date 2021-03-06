describe Dispatcher do
  describe '#parse' do
    subject(:dispatcher) { Dispatcher.new(robot: robot) }
    let(:robot) { Robot.new }

    describe 'PLACE command' do
      context 'given an invliad command' do
        it 'places robot' do
          dispatcher.parse('PLACE 0,1,NORTH')
          expect(robot.x).to eq(0)
          expect(robot.y).to eq(1)
          expect(robot.orientation).to eq(:north)
        end
      end

      context 'given an invalid command' do
        it 'does not place robot' do
          expect(robot).to_not be_placed
          dispatcher.parse('PLACE 0,6,SOUTH')
          expect(robot).to_not be_placed
        end
      end
    end

    describe 'LEFT command' do
      context 'when robot is placed on board' do
        before { dispatcher.parse('PLACE 1,2,SOUTH') }

        it 'turns robot left' do
          expect(robot).to be_placed
          dispatcher.parse('LEFT')
          expect(robot.orientation).to eq(:east)
        end
      end

      context 'when robot is placed off board' do
        before { dispatcher.parse('PLACE 6,0,WEST') }

        it 'does not place robot' do
          expect(robot).to_not be_placed
          dispatcher.parse('LEFT')
          expect(robot).to_not be_placed
        end
      end
    end

    describe 'RIGHT command' do
      context 'when robot is placed on board' do
        before { dispatcher.parse('PLACE 1,2,SOUTH') }

        it 'turns robot right' do
          expect(robot).to be_placed
          dispatcher.parse('RIGHT')
          expect(robot.orientation).to eq(:west)
        end
      end

      context 'when robot is placed off board' do
        before { dispatcher.parse('PLACE 6,0,WEST') }

        it 'does not place robot' do
          expect(robot).to_not be_placed
          dispatcher.parse('RIGHT')
          expect(robot).to_not be_placed
        end
      end
    end

    describe 'REPORT command' do
      before { allow(STDOUT).to receive(:puts) }

      context 'when placed on board' do
        before { dispatcher.parse('PLACE 4,0,EAST') }

        it 'reports X, Y, and orientation' do
          expect(robot).to be_placed
          dispatcher.parse('REPORT')
          expect(STDOUT).to have_received(:puts).with('4,0,EAST')
        end
      end
      context 'when placed off board' do
        before { dispatcher.parse('PLACE 5,0,WEST') }

        it 'ignores command' do
          expect(robot).to_not be_placed
          dispatcher.parse('REPORT')
          expect(STDOUT).to_not have_received(:puts)
        end
      end
    end

    describe 'MOVE command' do
      context 'when directed to move on board' do
        before { dispatcher.parse('PLACE 3,0,EAST') }

        it 'moves robot as directed' do
          dispatcher.parse('MOVE')
          expect(robot.x).to eq(4)
          expect(robot.y).to eq(0)
        end
      end

      context 'when directed to move off board' do
        before { dispatcher.parse('PLACE 4,0,EAST') }

        it 'ignores command' do
          dispatcher.parse('MOVE')
          expect(robot.x).to eq(4)
          expect(robot.y).to eq(0)
        end
      end
    end
  end
end
