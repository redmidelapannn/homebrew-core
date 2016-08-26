class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  head "https://gitlab.com/procps-ng/procps.git"

  stable do
    url "https://gitlab.com/procps-ng/procps.git",
      :tag => "v3.3.11",
      :revision => "de985eced583f18df273146b110491b0f7404aab"

    # Upstream commit, which (probably inadvertently) fixes the error
    # "conflicting types for 'user_from_uid"
    # Commit subject is "watch: Correctly process [m Remove lib dependency"
    # Preexisting upstream report: https://gitlab.com/procps-ng/procps/issues/34
    patch do
      url "https://gitlab.com/procps-ng/procps/commit/99fa7f9f.diff"
      sha256 "7f907db30f4777746224506b120d5d402c01073fbd275e83d37259a8eb4f62b1"
    end
  end

  bottle do
    rebuild 1
    sha256 "f61de5d04ae87a04a2c4bff33226023e9de129a1d9ce738100c40f537f482cd3" => :el_capitan
    sha256 "ba85861438d7d30b8463bd6c0bbe59f6dcc6588c5f5abba52343fe5964a8a81f" => :yosemite
    sha256 "81d91b3cf9734380aadf5d9bffbb2a398cfee11bc9e90d039ced9330acb217b5" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"

  conflicts_with "visionmedia-watch"

  def install
    # Prevents undefined symbol errors for _libintl_gettext, etc.
    # Reported 22 Jun 2016: https://gitlab.com/procps-ng/procps/issues/35
    ENV.append "LDFLAGS", "-lintl"

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "watch"
    bin.install "watch"
    man1.install "watch.1"
  end

  test do
    ENV["TERM"] = "xterm"
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
