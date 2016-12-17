class Moreutils < Formula
  desc "Collection of tools that nobody wrote when UNIX was young"
  homepage "https://joeyh.name/code/moreutils/"
  url "git://git.kitenet.net/moreutils",
      :tag => "0.60",
      :revision => "1173bd9f10d731485f3b63f1c7ff55eb9c58a605"
  head "git://git.joeyh.name/moreutils"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6d4e5024bf726e6e93439b66f45b7febd95958e5b7f621d3e917b0079dd8fd64" => :sierra
    sha256 "23a2037913e8bebf5354c206dee6080385e528cd7ed2e77c768004255ea74a68" => :el_capitan
    sha256 "f1b91c25ab6db2fe0d02df89772c2743ab633e7125b2ee0c929f9e7614bd5a87" => :yosemite
  end

  option "without-parallel", "Build without the 'parallel' tool."
  option "without-errno",    "Build without the 'errno' tool, for compatibility with 'pwntools'."
  option "without-ts",       "Build without the 'ts' tool, for compatibility with 'task-spooler'."

  depends_on "docbook-xsl" => :build

  conflicts_with "parallel", :because => "Both install a `parallel` executable."  if build.with? "parallel"
  conflicts_with "pwntools", :because => "Both install an `errno` executable."    if build.with? "errno"
  conflicts_with "task-spooler", :because => "Both install a `ts` executable."    if build.with? "ts"

  resource "Time::Duration" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Time-Duration-1.20.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/N/NE/NEILB/Time-Duration-1.20.tar.gz"
    sha256 "458205b528818e741757b2854afac5f9af257f983000aae0c0b1d04b5a9cbbb8"
  end

  resource "IPC::Run" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/IPC-Run-0.94.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/T/TO/TODDR/IPC-Run-0.94.tar.gz"
    sha256 "2eb336c91a2b7ea61f98e5b2282d91020d39a484f16041e2365ffd30f8a5605b"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("Time::Duration").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "--skipdeps"
      system "make", "install"
    end

    resource("IPC::Run").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    inreplace "Makefile",
              "/usr/share/xml/docbook/stylesheet/docbook-xsl",
              "#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
    if build.without? "parallel"
      inreplace "Makefile", /^BINS=.*\Kparallel/, ""
      inreplace "Makefile", /^MANS=.*\Kparallel\.1/, ""
    end
    if build.without? "errno"
      inreplace "Makefile", /^BINS=.*\Kerrno/, ""
      inreplace "Makefile", /^MANS=.*\Kerrno\.1/, ""
    end
    if build.without? "ts"
      inreplace "Makefile", /^PERLSCRIPTS=.*\Kts/, ""
      inreplace "Makefile", /^MANS=.*\Kts\.1/, ""
    end
    system "make", "all"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    pipe_output("#{bin}/isutf8", "hello", 0)
    pipe_output("#{bin}/isutf8", "\xca\xc0\xbd\xe7", 1)
  end
end
