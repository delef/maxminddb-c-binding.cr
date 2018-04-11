# ![GeoIP2.cr](https://user-images.githubusercontent.com/2103263/29317820-5bde9508-81d6-11e7-9aff-bb835b87c344.png)
Pure Crystal [GeoIP2 MaxMind DB](https://github.com/maxmind/libmaxminddb/) binding

## Installation C-lib

### From the Git Repository

To install from Git, you will need automake, autoconf, and libtool installed
in addition to make and a compiler.

Our public git repository is hosted on GitHub at
https://github.com/maxmind/libmaxminddb

You can clone this repository and build it by running:

    $ git clone --recursive https://github.com/maxmind/libmaxminddb

After cloning, run `./bootstrap` from the `libmaxminddb` directory and then
follow the instructions for installing from a tarball as described above.

### On Ubuntu via PPA

MaxMind provides a PPA for recent version of Ubuntu. To add the PPA to your
APT sources, run:

    $ sudo add-apt-repository ppa:maxmind/ppa

Then install the packages by running:

    $ sudo aptitude update
    $ sudo aptitude install libmaxminddb0 libmaxminddb-dev mmdb-bin

### On OS X via Homebrew

If you are on OS X and you have homebrew (see http://brew.sh/) you can install
libmaxminddb via brew.

    $ brew install libmaxminddb

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  geoip2:
    github: delef/geoip2.cr
```

## Usage

```crystal
require "geoip2"
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/delef/geoip2.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [delef](https://github.com/delef) - creator, maintainer
- [akzhan](https://github.com/akzhan) - lookup data walk
- [unn4m3d](https://github.com/unn4m3d) - data padding fixes
