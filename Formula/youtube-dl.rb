# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.01.31/youtube-dl-2017.01.31.tar.gz"
  sha256 "ddb1445eb18425413651267f4fbe2ea06198f7b253812fd69bd90a6804ae8c57"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5de352de83df1e6c1ef50c80eb87c42ae23f4fc91479eca047c46e9d5ac5cd8" => :sierra
    sha256 "f8642bda6d532f95b986fcc81141863de598ec5b72d6257b945c02db32ac06ab" => :el_capitan
    sha256 "e5de352de83df1e6c1ef50c80eb87c42ae23f4fc91479eca047c46e9d5ac5cd8" => :yosemite
  end

  head do
    url "https://github.com/rg3/youtube-dl.git"
    depends_on "pandoc" => :build
  end

  depends_on "rtmpdump" => :optional

  def install
    system "make", "PREFIX=#{prefix}"
    bin.install "youtube-dl"
    man1.install "youtube-dl.1"
    bash_completion.install "youtube-dl.bash-completion"
    zsh_completion.install "youtube-dl.zsh" => "_youtube-dl"
    fish_completion.install "youtube-dl.fish"
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=AEhULv4ruL4&list=PLZdCLR02grLrl5ie970A24kvti21hGiOf"
  end
end
