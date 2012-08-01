# 1) First follow the instructions in SETUP_RVM_RAILS_PASSENGER_NGINX to get your system running right

# 2) Install postgresql 9.1 (seem to have some problems with 8.4) (see https://gist.github.com/1481128)
sudo apt-get -y install python-software-properties
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update 

# the big list of apt dependencies to check we have installed
sudo apt-get -y install postgis postgresql-9.1 postgresql-server-dev-9.1 postgresql-contrib-9.1 postgis  gdal-bin binutils libgeos-3.2.0 libgeos-c1 libgeos-dev libgdal1-dev libxml2 libxml2-dev libxml2-dev checkinstall proj libpq-dev

# make a directory for the postgis scripts
sudo mkdir -p '/usr/share/postgresql/9.1/contrib/postgis-1.5'

# fetch, compile and install PostGIS
wget http://postgis.refractions.net/download/postgis-1.5.3.tar.gz
tar zxvf postgis-1.5.3.tar.gz && cd postgis-1.5.3/
sudo ./configure && sudo make && sudo checkinstall --pkgname postgis-1.5.3 --pkgversion 1.5.3-src --default

# now create the template_postgis database template
sudo su postgres -c'createdb -E UTF8 -U postgres template_postgis'
sudo su postgres -c'createlang -d template_postgis plpgsql;'
sudo su postgres -c'psql -U postgres -d template_postgis -c"CREATE EXTENSION hstore;"'
sudo su postgres -c'psql -U postgres -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql'
sudo su postgres -c'psql -U postgres -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql'
sudo su postgres -c'psql -U postgres -d template_postgis -c"select postgis_lib_version();"'
sudo su postgres -c'psql -U postgres -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"'
sudo su postgres -c'psql -U postgres -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"'
sudo su postgres -c'psql -U postgres -d template_postgis -c "GRANT ALL ON geography_columns TO PUBLIC;"'