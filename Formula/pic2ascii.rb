class Pic2ascii < Formula
  desc "Converts a picture and video to ascii"
  homepage "https://github.com/wzshiming/pic2ascii"
  url "https://github.com/wzshiming/pic2ascii/archive/v1.4.3.tar.gz"
  sha256 "15d9d21399ac3560b9d919b7d643d74c9c82bde5942e4d0ebed06109dd9236ae"

  bottle do
    cellar :any
    sha256 "aefeb65eec51d2e0846322db0ac9dad00e8bf43de7263194012b1f26b8aff49d" => :high_sierra
    sha256 "ef7eb72948d18d668fbb62b48bc37b9dd77030b704f47d135fdad59a3ffd1d89" => :sierra
    sha256 "aaf40110851d033187d4e1c7b1559ec177cae6640f516d63e638689aff9ee2c7" => :el_capitan
  end

  depends_on "ffmpeg" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/wzshiming/pic2ascii/"
    dir.install Dir["*"]
    cd dir do
      system "go", "build", "-tags=support_video", "-o", bin/"pic2ascii", "./cmd/pic2ascii"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"pic2ascii", "-f", "https://avatars0.githubusercontent.com/u/6565744", "-w", "80", "-h", "40", "-r", "-t", "gif"
  end
end
