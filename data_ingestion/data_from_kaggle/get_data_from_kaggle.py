import os


def get_data_from_kaggle():
    """Funkcja pobiera dane na temat zakópów z Kaggle."""
    config_path = os.path.join(os.path.dirname(__file__), "..", "..", "config")

    os.environ["KAGGLE_CONFIG_DIR"] = str(config_path)
    print("CONFIG DIR:", os.environ["KAGGLE_CONFIG_DIR"])
    print("FILES:", os.listdir(os.environ["KAGGLE_CONFIG_DIR"]))
    from kaggle.api.kaggle_api_extended import KaggleApi
    api = KaggleApi()
    api.authenticate()

    dataset = "olistbr/brazilian-ecommerce"
    download_path = "./data"

    os.makedirs(download_path, exist_ok=True)

    api.dataset_download_files(
        dataset,
        path=download_path,
        unzip=True
    )
    print('Zakończono pobieranie danych z Kaggle')

def insert_data_to_db():
    """Funkcja wstawia dane do bazy danych."""
    pass


if __name__ == "__main__":
    get_data_from_kaggle()
