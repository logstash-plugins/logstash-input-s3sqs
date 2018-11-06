# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/inputs/s3sqs"
require 'aws-sdk'

describe LogStash::Inputs::S3SQS do

  context 'an s3sqs plugin' do
    let (:poller) { double('poller')}
    before :each do
      allow(subject).to receive(:setup_queue)
      allow(subject).to receive(:poller).and_return poller
      allow(poller).to receive(:before_request).and_return Aws::SQS::QueuePoller::PollerStats.new
      allow(poller).to receive(:poll) do |_|
        sleep(2)
      end
    end

    it_behaves_like "an interruptible input plugin" do
      let(:config) { { "queue" => 'queue'} }
    end
  end
end
