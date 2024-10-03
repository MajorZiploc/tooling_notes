jest mocking example:
```
/* eslint-disable */
jest.mock( '@react-google-maps/api', () => {
    return {
        ...jest.requireActual( '@react-google-maps/api' ),
        Marker: ( { onMouseOver, onMouseOut, ...props } ) => (
            <div
                data-testid="Marker"
                data-props={JSON.stringify( props, null, 2 )}
                onMouseOver={onMouseOver}
                onMouseOut={onMouseOut}
            />
        ),
        useGoogleMap: (): any => ({
            setOptions: jest.fn(),
            getMapTypeId: jest.fn(),
            setMapTypeId: jest.fn(),
            data: {
                setStyle: jest.fn(),
                addGeoJson: jest.fn(),
            },
            fitBounds: jest.fn(),
        }),
    };
} );
jest.mock( '../../../../components/MapControlHole', () => ( props ) => (
    <div
        id="MapControlHole"
        data-testid="MapControlHole"
        data-props={JSON.stringify( props, null, 2 )}
    />
) );
jest.mock( 'react-router-dom', () => ({
    Link: ( { children, ...props } ) => (
        <div
            id="Link"
            data-testid="Link"
            data-props={JSON.stringify( props, null, 2 )}
        >
            {children}
        </div>
    ),
}) );
/* eslint-enable */

```
