FactoryBot.define do
  factory :video do
    title { "Sample Video" }
    description { "This is a sample video." }
    url { "http://example.com/sample_video" }
    thumbnail_url { "http://example.com/sample_thumbnail" }
  end
end
