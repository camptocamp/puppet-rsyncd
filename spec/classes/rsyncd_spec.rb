require 'spec_helper'

describe 'rsyncd' do

  let(:pre_condition) {
    "
    package { ['rsync', 'xinetd']: ensure => present }
    service { 'xinetd': ensure => running }
    "
  }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :augeasversion => '1.0.0',
        })
      end

      it { should compile.with_all_deps }
    end
  end
end
