require "language/go"

class Migrate < Formula
  desc "Go CLI for database migrations"
  homepage "https://github.com/mattes/migrate"
  url "https://github.com/mattes/migrate/archive/v3.0.1.tar.gz"
  sha256 "c3847f260e283929db8a39d8a0273db2f6c2d96ab3aee2dba7053a83f4b61e22"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ea2e146eb0ee73ce2aec47252672548900f4dee404011490702d7bf3178b2b6" => :sierra
    sha256 "7afd373ba2a169605789b31a9e5fef1cbb12c46d318002a1b62d323277bc6df3" => :el_capitan
    sha256 "abbe8cbe014269d799b8418d747388dca2e7085a0aa7318c0d2047d8632e99db" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/lib/pq" do
    url "https://github.com/lib/pq.git",
        :revision => "8837942c3e09574accbc5f150e2c5e057189cace"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/mattes").mkpath
    ln_s buildpath, buildpath/"src/github.com/mattes/migrate"

    cd buildpath/"src/github.com/mattes/migrate/cli" do
      system "go", "build", "-tags", "'postgres'",
             "-o", "./migrate", "."

      bin.install "migrate"
    end
  end

  test do
    system bin/"migrate", "-version"
  end
end
