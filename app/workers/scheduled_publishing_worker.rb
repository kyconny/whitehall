class ScheduledPublishingWorker
  include Sidekiq::Worker

  class ScheduledPublishingFailure < StandardError; end

  # 5 retries over 10 mins
  sidekiq_options :retry => 5
  sidekiq_retry_in do |count|
    # 16s, 31s, 96s, 271s, 640s
    count ** 4 + 15
  end

  def self.cancel_scheduled_publishing(cancel_edition_id)
    Sidekiq::ScheduledSet.new.select do |scheduled_job|
      scheduled_job.args.first == cancel_edition_id
    end.map(&:delete)
  end

  def perform(edition_id, user_id)
    user = User.find(user_id)
    edition = Edition.find(edition_id)
    publish_edition_as_user(edition, user) unless edition.published?
  end

  private

  def publish_edition_as_user(edition, user)
    Edition::AuditTrail.acting_as(user) do
      publisher = Whitehall.edition_services.scheduled_publisher(edition)
      unless publisher.perform!
        raise ScheduledPublishingFailure, publisher.failure_reason
      end
    end
  end
end
