{{ config(
        tags = ['dunesql'],
        alias = alias('bnb_rolling_hour'))
}}

        SELECT
            blockchain, 
            hour, 
            wallet_address,
            token_address,
            symbol, 
            CAST(NOW() as timestamp) as last_updated,
            ROW_NUMBER() OVER (PARTITION BY token_address, wallet_address ORDER BY hour DESC) as recency_index,
            SUM(amount_raw) OVER (PARTITION BY token_address, wallet_address ORDER BY hour) as amount_raw, 
            SUM(amount) OVER (PARTITION BY token_address, wallet_address ORDER BY hour) as amount          
        FROM 
        {{ ref('transfers_bnb_bnb_agg_hour') }}