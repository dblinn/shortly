require 'rake'
require './lib/tasks/db'
require './models/short_url'

namespace :metrics do
  URL_SEEDS =
    %w(
      http://www.bemyeyes.org/
      http://aadrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html
      http://paulgraham.com/work.html
      https://github.com/ValveSoftware/steam-for-linux/issues/3671
      https://vine.co/v/OjqeYWWpVWK
      https://krita.org/item/goodbye-photoshop-and-hello-krita-at-university-paris-8/
      http://www.mattblodgett.com/2015/01/but-where-do-people-work-in-this-office.html
      http://motherboard.vice.com/read/defense-in-silk-road-trial-says-mt-gox-ceo-was-the-real-dread-pirate-roberts?utm_source=mbtwitter
      http://ferd.ca/awk-in-20-minutes.html
      https://github.com/alex/what-happens-when
      http://www.spiegel.de/international/world/new-snowden-docs-indicate-scope-of-nsa-preparations-for-cyber-battle-a-1013409.html
      http://www.bbc.co.uk/news/technology-30831128
      http://www.itinthed.com/16328/what-taking-my-daughter-to-a-comic-book-store-taught-me
      http://jlongster.com/Presenting-The-Most-Over-Engineered-Blog-Ever
      https://research.facebook.com/blog/879898285375829/fair-open-sources-deep-l20earning-modules-for-torch/
      http://brm.io/matter-js/
      https://gigaom.com/2015/01/16/in-surprise-shift-sprint-endorses-net-neutrality/
      http://stackoverflow.com/questions/5168718/what-blocks-ruby-python-to-get-javascript-v8-speed
      http://www.washingtonpost.com/investigations/holder-ends-seized-asset-sharing-process-that-split-billions-with-local-state-police/2015/01/16/0e7ca058-99d4-11e4-bcfb-059ec7a93ddc_story.html
      https://medium.com/funny-stuff/the-fine-art-of-bullshit-c09f7bbb391e
      http://jacquesmattheij.com/Salary+negotiations+for+techies#
      http://recode.net/2015/01/13/how-amazon-tricks-you-into-thinking-it-always-has-the-lowest-prices/
      http://www.dogmedicationdb.com/
      http://www.bbc.co.uk/news/science-environment-30784886
      https://news.ycombinator.com/item?id=8908279
      http://petapixel.com/2015/01/16/31-rolls-undeveloped-film-soldier-wwii-discovered-processed/
      http://blogs.msdn.com/b/typescript/archive/2015/01/16/announcing-typescript-1-4.aspx
      http://www.newyorker.com/magazine/2015/01/26/whole-haystack
      http://loicpefferkorn.net/2015/01/arch-linux-on-macbook-pro-retina-2014-with-dm-crypt-lvm-and-suspend-to-disk/
      http://www.belfasttelegraph.co.uk/news/local-national/northern-ireland/bbc-uses-ripa-terrorism-laws-to-catch-tv-licence-fee-dodgers-in-northern-ireland-30911647.html
      http://www.agrisupply.com/equipment-supplies/top-link-long-mm-cat-p-11903.php
      http://www.agrisupply.com/equipment-supplies/jd-toplink-with-quick-release-&-knuckle-p-57352.php
      http://www.agrisupply.com/equipment-supplies/ratchet-jack-adjustable-with-lock-p-38124.php
      http://www.agrisupply.com/equipment-supplies/top-link-long-p-11901.php
      http://www.agrisupply.com/equipment-supplies/jd-top-link-cat-2-20-center-tube-leng-p-27916.php
      http://www.agrisupply.com/equipment-supplies/top-link-cat-kubota-center-p-33358.php
      http://www.agrisupply.com/equipment-supplies/lift-arm-leveling-assy-cat-p-11921.php
      http://www.agrisupply.com/equipment-supplies/top-link-cat-center-tube-length-p-11929.php
      http://www.agrisupply.com/equipment-supplies/rep-end-left-hand-cat-cat-bshg-jumbo-p-27721.php
      http://www.agrisupply.com/equipment-supplies/top-link-cylinder-p-84745.php
      http://www.agrisupply.com/equipment-supplies/hydraulic-top-link-category-stroke-p-67464.php
      http://www.agrisupply.com/equipment-supplies/hydraulink-cat-2-self-contained-top-link-p-79304.php
      http://www.nytimes.com/2015/01/20/world/middleeast/us-support-for-syria-peace-plans-demonstrates-shift-in-priorities.html
      http://www.nytimes.com/2015/01/20/world/americas/alberto-nisman-found-dead-argentina-amia.html
      http://www.nytimes.com/2015/01/20/us/king-holiday-events-include-air-of-protest-over-deaths-of-black-men.html
      http://www.nytimes.com/2015/01/20/us/politics/cody-keenan-obamas-hemingway-draws-on-friends-empathy-and-a-little-whisky-for-state-of-the-union.html
      http://www.nytimes.com/2015/01/19/us/cubans-convicted-in-the-us-face-new-fears-of-deportation.html
      http://www.nytimes.com/2015/01/20/us/scalia-lands-at-top-of-sarcasm-index-of-justices-shocking.html
      http://www.nytimes.com/2015/01/20/business/energy-environment/in-texas-hunkering-down-for-the-oil-bust.html
      http://www.nytimes.com/2015/01/19/world/asia/nsa-tapped-into-north-korean-networks-before-sony-attack-officials-say.html
      http://www.nytimes.com/2015/01/20/business/energy-environment/in-texas-hunkering-down-for-the-oil-bust.html
      http://www.nytimes.com/2015/01/20/technology/shifting-politics-of-net-neutrality-debate-ahead-of-fcc-vote.html
      http://www.nytimes.com/2015/01/20/science/millennials-set-to-outnumber-baby-boomers.html
      http://www.nytimes.com/2015/01/20/sports/skiing/super-g-win-gives-lindsey-vonn-world-cup-record.html
      http://www.nytimes.com/2015/01/16/movies/blackhat-a-cyberthriller-starring-chris-hemsworth.html
      http://www.nytimes.com/2015/01/18/realestate/what-750000-buys-you-in-new-york-city.html
      http://xkcd.com/1051/
      http://xkcd.com/1000/
      http://xkcd.com/824/
      http://xkcd.com/825/
      http://xkcd.com/826/
      http://xkcd.com/827/
      http://xkcd.com/828/
      http://xkcd.com/829/
      http://xkcd.com/830/
      http://xkcd.com/831/
      http://xkcd.com/832/
      http://xkcd.com/833/
      http://xkcd.com/150/
      http://xkcd.com/151/
      http://xkcd.com/152/
      http://xkcd.com/153/
      http://xkcd.com/154/
      http://xkcd.com/155/
      http://xkcd.com/156/
      http://xkcd.com/157/
      http://xkcd.com/158/
      http://xkcd.com/159/
    )

  def rand_url
    Shortly::ShortUrl.find_or_create_by(source_url: URL_SEEDS.sample)
  end

  desc 'Seed a list of urls with accesses to make the top hundred page more interesting (default 100)'
  task :seed_accesses, [:access_count] do |task, args|
    establish_db_environment

    access_count = (args[:access_count] || 100).to_i
    access_count.times do
      url = rand_url
      url.increment_times_shortened if url.times_shortened == 0
      url.increment_times_accessed
    end
  end

  desc 'Seed a list of urls with shortenings to make the top hundred page more interesting (default 100)'
  task :seed_shortenings, [:access_count] do |task, args|
    establish_db_environment

    access_count = (args[:access_count] || 100).to_i
    access_count.times do
      rand_url.increment_times_shortened
    end
  end
end