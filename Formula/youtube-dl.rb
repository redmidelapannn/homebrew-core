# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.01.08/youtube-dl-2017.01.08.tar.gz"
  sha256 "ac2942d001003575858ff044dd1c1c264ab08527efa1af7036f773ea82b25fd6"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfd645193430d463d12170631d9dab9d210e33caabdfb187f41ea7c77a6cae37" => :sierra
    sha256 "3b0778bb8503559fb255e8c3694edbe7943295d5d0bf297e3167d0df34cff84c" => :el_capitan
    sha256 "3b0778bb8503559fb255e8c3694edbe7943295d5d0bf297e3167d0df34cff84c" => :yosemite
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
