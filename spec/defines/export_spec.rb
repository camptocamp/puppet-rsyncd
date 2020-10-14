require 'spec_helper'

describe 'rsyncd::export' do
  let(:title) { 'test-export' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) do
        "
        package { ['rsync', 'xinetd']: ensure => 'present' }
        service { 'xinetd': ensure => 'running' }
        include rsyncd
        "
      end

      context 'with no parameters set' do
        it { is_expected.to compile.and_raise_error(%r{missing mandatory \$path parameter for rsyncd::export}) }
      end

      context 'with defaults parameters' do
        let(:params) { { 'path' => '/some/path' } }

        it { is_expected.to compile }
      end

      context 'with values set for every parameter' do
        let(:params) do
          {
            'ensure'   => 'present',
            'chroot'   => false,
            'readonly' => false,
            'path'     => '/some/path',
            'uid'      => 'user1',
            'gid'      => 'group1',
            'incomingchmod' => 'go-w,+X',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_augeas("setup rsyncd export #{title}").with(
            'changes' => [
              "set '#{title}/#comment' 'created by rsyncd::export(#{title})'",
              "set '#{title}/path' '/some/path'",
              "set '#{title}/use\\ chroot' false",
              "set '#{title}/read\\ only' false",
            ],
          )
        }
        it { is_expected.to contain_augeas("set rsyncd uid for #{title}").with_changes("set '#{title}/uid' user1") }
        it { is_expected.to contain_augeas("set rsyncd gid for #{title}").with_changes("set '#{title}/gid' group1") }
        it { is_expected.to contain_augeas("set incoming chmod for #{title}").with_changes("set '#{title}/incoming\\ chmod' go-w,+X") }
      end

      context 'with ensure absent' do
        let(:params) { { 'ensure' => 'absent' } }

        it { is_expected.to compile }
        it { is_expected.to contain_augeas("remove #{title}").with_changes("remove '#{title}'") }
      end

      context 'with unknown ensure' do
        let(:params) { { 'ensure' => 'quirky' } }

        it { is_expected.to compile.and_raise_error(%r{Unknown value for ensure: quirky}) }
      end
    end
  end
end
