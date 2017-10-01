class Pacparser < Formula
  desc "Library to parse proxy auto-config (PAC) files"
  homepage "https://github.com/pacparser/pacparser"
  url "https://github.com/pacparser/pacparser/archive/1.3.7.tar.gz"
  sha256 "575c5d8096b4c842b2af852bbb8bcfde96170b28b49f33249dbe2057a8beea13"
  head "https://github.com/pacparser/pacparser.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "877dacd87f6c31fad8dd0a7c6433d42f34dd26981dc58ced91f3fd48ca137188" => :high_sierra
    sha256 "0d34df8b8a9ba119287541fc7110eb2c8fd5d60176355fb1fbb204cd10700d5c" => :sierra
    sha256 "9466b0aafde165a31dd1ea38d5c12b4bb77ec8314fe04a6a7317a9a91edc0394" => :el_capitan
  end

  depends_on "python" => :optional

  def install
    # Disable parallel build due to upstream concurrency issue.
    # https://github.com/pacparser/pacparser/issues/27
    ENV.deparallelize
    ENV["VERSION"] = version
    Dir.chdir "src"
    system "make", "install",
           "PREFIX=#{prefix}"
    if build.with? "python"
      system "make", "install-pymod",
             "EXTRA_ARGS=\"--prefix=#{prefix}\""
    end
  end

  test do
    # example pacfile taken from upstream sources
    (testpath/"test.pac").write <<-'EOS'.undent
      function FindProxyForURL(url, host) {

        if ((isPlainHostName(host) ||
            dnsDomainIs(host, ".manugarg.com")) &&
            !localHostOrDomainIs(host, "www.manugarg.com"))
          return "plainhost/.manugarg.com";

        // Return externaldomain if host matches .*\.externaldomain\.example
        if (/.*\.externaldomain\.example/.test(host))
          return "externaldomain";

        // Test if DNS resolving is working as intended
        if (dnsDomainIs(host, ".google.com") &&
            isResolvable(host))
          return "isResolvable";

        // Test if DNS resolving is working as intended
        if (dnsDomainIs(host, ".notresolvabledomain.invalid") &&
            !isResolvable(host))
          return "isNotResolvable";

        if (/^https:\/\/.*$/.test(url))
          return "secureUrl";

        if (isInNet(myIpAddress(), '10.10.0.0', '255.255.0.0'))
          return '10.10.0.0';

        if ((typeof(myIpAddressEx) == "function") &&
            isInNetEx(myIpAddressEx(), '3ffe:8311:ffff/48'))
          return '3ffe:8311:ffff';

        else
          return "END-OF-SCRIPT";
      }
    EOS
    # Functional tests from upstream sources
    test_sets = [
      {
        "cmd" => "-c 3ffe:8311:ffff:1:0:0:0:0 -u http://www.example.com",
        "res" => "3ffe:8311:ffff",
      },
      {
        "cmd" => "-c 0.0.0.0 -u http://www.example.com",
        "res" => "END-OF-SCRIPT",
      },
      {
        "cmd" => "-u http://host1",
        "res" => "plainhost/.manugarg.com",
      },
      {
        "cmd" => "-u http://www1.manugarg.com",
        "res" => "plainhost/.manugarg.com",
      },
      {
        "cmd" => "-u http://manugarg.externaldomain.example",
        "res" => "externaldomain",
      },
      {
        "cmd" => "-u https://www.google.com",  ## internet
        "res" => "isResolvable",               ## required
      },
      {
        "cmd" => "-u https://www.notresolvabledomain.invalid",
        "res" => "isNotResolvable",
      },
      {
        "cmd" => "-u https://www.example.com",
        "res" => "secureUrl",
      },
      {
        "cmd" => "-c 10.10.100.112 -u http://www.example.com",
        "res" => "10.10.0.0",
      },
    ]
    # Loop and execute tests
    test_sets.each do |t|
      assert_equal t["res"],
        shell_output("#{bin}/pactester -p #{testpath}/test.pac " +
          t["cmd"]).strip
    end
  end
end
