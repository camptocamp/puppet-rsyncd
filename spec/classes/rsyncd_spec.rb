require 'spec_helper'

describe 'rsyncd' do
  let(:pre_condition) do
    "
    package { ['rsync', 'xinetd']: ensure => present }
    service { 'xinetd': ensure => running }
    "
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(augeasversion: '1.0.0')
      end

      it { is_expected.to compile.with_all_deps }
    end
  end
end
