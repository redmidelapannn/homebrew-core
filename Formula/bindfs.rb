class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.14.4.tar.gz"
  sha256 "87a168d0198d76793149bb0fae18679aa602352ec649b53dd96f048ff01264ee"

  bottle do
    cellar :any
    sha256 "502774c6f44b78778ab632699ab8660a4f25bf3679ac4e3b7ea59c9d95cedbae" => :catalina
    sha256 "e99ff981ec079a926bc35ef932d08de4b6ca778fd6919673e48ca9078cd28f7e" => :mojave
    sha256 "e8614bb968b8255176aa9da32602840fa1f25b59cf6581b4bc1063eaef1cb0b0" => :high_sierra
  end

  head do
    url "https://github.com/mpartel/bindfs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
