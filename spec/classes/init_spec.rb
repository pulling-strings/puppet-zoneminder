require 'spec_helper'
describe 'zoneminder' do

  context 'with defaults for all parameters' do
    it { should contain_class('zoneminder') }
  end
end
