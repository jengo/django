node()
{
        // If you get port conflicts, you can change these to be non-standard
        // There are also Jenkins plugins that you can use to randomize these
        env.MYSQL_PORT       = 3306
        env.POSTGRES_PORT    = 5432
        env.NGINX_HTTP_PORT  = 80
        env.NGINX_HTTPS_PORT = 443

        // Uncomment this if you aren't using a multi-branch pipeline
        // Obviously also change it to your scm location
        /*
        stage("checkout")
        {
                git 'https://github.com/jengo/django-sampleoutput'
        }*/

        stage("Clean")
        {
                // Default is to reset everything for a fresh run
                sh 'make clean'
                sh 'docker volume rm build_jengo_django_mysql_data build_jengo_django_postgres_data || true'
        }

        stage("Build")
        {
                sh 'make depends'
        }

        stage("Test")
        {
                sh 'make test'
        }

        stage("Deploy")
        {
                sh 'make deploy'
        }
}
