class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets."
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v0.3.1.tar.gz"
  sha256 "5ff34f07a503a8d1b22911409dfd426d16a451b76a3deff503363db17204b9cb"

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    require "time"
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    mkdir_p buildpath/"src/github.com/pilosa/"
    ln_s buildpath, buildpath/"src/github.com/pilosa/pilosa"
    system "glide", "install"
    ts = Time.now.utc.strftime("%FT%T%z")
    system "go", "build", "-o", bin/"pilosa", "-ldflags",
           "-X github.com/pilosa/pilosa/cmd.Version=#{version} -X github.com/pilosa/pilosa/cmd.BuildTime=#{ts}",
           "github.com/pilosa/pilosa/cmd/pilosa"
  end

  test do
    system "#{bin}/pilosa", "--help"
  end
end
