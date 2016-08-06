class Xapian < Formula
  desc "C++ search engine library with many bindings"
  homepage "https://xapian.org/"

  stable do
    url "http://oligarchy.co.uk/xapian/1.4.0/xapian-core-1.4.0.tar.xz"
    sha256 "10584f57112aa5e9c0e8a89e251aecbf7c582097638bfee79c1fe39a8b6a6477"

    resource "bindings" do
      url "http://oligarchy.co.uk/xapian/1.4.0/xapian-bindings-1.4.0.tar.xz"
      sha256 "3aec7a009d0bf0b95968420bf68683176c05d63140eaf1cf265d39afe8fa6253"
    end
  end

  bottle do
    cellar :any
    sha256 "6558e4ec32347d17cc4ac43a822a4d399aa0dc518c01f6f3529e9aea410e5108" => :el_capitan
    sha256 "1d48951c5c10673b6d35c20ad5c7481084cfad5da837b7898998e428daab42ed" => :yosemite
    sha256 "e7b28aed51b686e7836e3b9d9600b0f95edff643ce692481e8a68823156cfacb" => :mavericks
  end

  option "with-java", "Java bindings"
  option "with-php", "PHP bindings"
  option "with-ruby", "Ruby bindings"

  deprecated_option "java" => "with-java"
  deprecated_option "php" => "with-php"
  deprecated_option "ruby" => "with-ruby"

  depends_on :python => :optional
  depends_on "sphinx-doc" => :build if build.with? "python"
  depends_on :ruby => "2.1"

  skip_clean :la

  def install
    build_binds = build.with?("ruby") || build.with?("python") || build.with?("java") || build.with?("php")

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    if build_binds
      resource("bindings").stage do
        args = %W[
          --disable-dependency-tracking
          --prefix=#{prefix}
          XAPIAN_CONFIG=#{bin}/xapian-config
          --without-csharp
          --without-tcl
          SPHINX_BUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
        ]

        if build.with? "java"
          args << "--with-java"
        else
          args << "--without-java"
        end

        if build.with? "ruby"
          ruby_site = lib/"ruby/site_ruby"
          ENV["RUBY_LIB"] = ENV["RUBY_LIB_ARCH"] = ruby_site
          args << "--with-ruby"
        else
          args << "--without-ruby"
        end

        if build.with? "python"
          # https://github.com/Homebrew/homebrew-core/issues/2422
          ENV.delete("PYTHONDONTWRITEBYTECODE")

          (lib/"python2.7/site-packages").mkpath
          ENV["PYTHON_LIB"] = lib/"python2.7/site-packages"
          args << "--with-python"
        else
          args << "--without-python"
        end

        if build.with? "php"
          extension_dir = lib/"php/extensions"
          extension_dir.mkpath
          args << "--with-php" << "PHP_EXTENSION_DIR=#{extension_dir}"
        else
          args << "--without-php"
        end

        system "./configure", *args
        system "make", "install"
      end
    end
  end

  def caveats
    if build.with? "python"
      <<-EOS.undent
        You may need to add the following to your PYTHONPATH:
          #{HOMEBREW_PREFIX}/lib/python2.7/site-packages/xapian

      EOS
    end
    if build.with? "ruby"
      <<-EOS.undent
        You may need to add the Ruby bindings to your RUBYLIB from:
          #{HOMEBREW_PREFIX}/lib/ruby/site_ruby

      EOS
    end
  end

  test do
    system bin/"xapian-config", "--libs"
  end
end
