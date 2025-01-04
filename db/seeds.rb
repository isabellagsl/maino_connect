require "faker"

5.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email_address: Faker::Internet.email,
    password: "password",
    password_confirmation: "password"
  )
end

User.all.each do |user|
  3.times do
    Post.create!(
      title: Faker::Lorem.sentence,
      content: Faker::Lorem.paragraphs(number: rand(1..5)).join("\n\n"),
      user: user
    )
  end
end

Post.all.each do |post|
  rand(0..5).times do
    create_anonymous_comment = [ true, false ].sample
    user = create_anonymous_comment ? nil : User.all.sample
    PostComment.create!(
      content: Faker::Lorem.paragraph(sentence_count: rand(1..3)),
      post: post,
      user: user
    )
  end
end

Post.all.each do |post|
  rand(0..5).times do
    tag = PostTag.find_or_create_by(name: Faker::Lorem.word)
    PostTagging.create(post: post, post_tag: tag)
  end
end