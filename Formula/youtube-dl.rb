# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.02.24/youtube-dl-2017.02.24.tar.gz"
  sha256 "591f8e8de95f1da39fc153631333801555ac700f85add65d48aa616e0da83003"

  bottle do
    cellar :any_skip_relocation
    sha256 "f37f4438028f7fd0e3dd87c538b9d51199d30ab83ffc99e96b864c80700479e0" => :sierra
    sha256 "f37f4438028f7fd0e3dd87c538b9d51199d30ab83ffc99e96b864c80700479e0" => :el_capitan
    sha256 "f37f4438028f7fd0e3dd87c538b9d51199d30ab83ffc99e96b864c80700479e0" => :yosemite
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
