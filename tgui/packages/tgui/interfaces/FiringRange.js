import { useBackend } from '../backend';
import { Button, Section, LabeledList, NoticeBox, NumberInput, Box, ProgressBar, Table } from '../components';
import { Window } from '../layouts';

export const FiringRange = (props, context) => {
  const { data } = useBackend(context);
  return (
    <Window
      title="Firing Range Control"
      width={450}
      height={600}>
      <Window.Content
        scrollable>
          {data.active_target === 1 ? (
            <ActiveTarget />
          ) : (
            <SelectTarget />
          )}
      </Window.Content>
    </Window>
  );
};

const ActiveTarget = (props, context) => {
  const { act, date } = useBackend(context);
  const { damage_logs } = data;
  return (
    <div>
      <Section>
        <NoticeBox
          textAlign="center">
          {data.target_name}
        </NoticeBox>
        <ProgressBar
          color="blue"
          value={data.target_health/data.target_maxhealth}
          children={data.target_health + " / " + data.target_maxhealth} />
        <Button
          icon="fa-trash-alt-o"
          color="bad"
          onClick={() => act('reset')} />
      </Section>
      <Section
        name="Damage Log">
        <Table
          collapsing>
          <Table.Row>
            <Table.Cell>
              Damage
            </Table.Cell>
            <Table.Cell>
              Target Health
            </Table.Cell>
          </Table.Row>
          {data.damage_logs.map(DL => (
            <DamageEntry
              target_health={DL.health}
              damage={DL.damage}
              />
          ))}
        </Table>
      </Section>
    </div>
  );
};

const DamageEntry = (props, context) => {
  const { damage_log } = props;
  const { damage, target_health } = damage_log;
  return (
    <Table.Row>
      <Table.Cell>
        {damage}
      </Table.Cell>
      <Table.Cell>
        {target_health}
      </Table.Cell>
    </Table.Row>
  );
};

const SelectTarget = (props, context) => {
  const { data } = useBackend(context);
  const { available_targets } = data;
  return(
    <Section>
      <Table>
        {available_targets.map(AT => (
          <TargetEntry
            key={AT.available_target}
            available_target={AT} />
        ))}
      </Table>
    </Section>
  );
};

const TargetEntry = (props, context) => {
  const { available_target } = props;
  const { available_target_name, young, mature, elder, ancient} = available_target;
  return(
    <Table.Row>
      <Table.Cell>
        {available_target_name}
      </Table.Cell>
      <Table.Cell>
        <Button
          my={1}
          mx={3}
          color='good'
          content="Young"
          disabled={young ? false : true}
          onClick={() => act('spawn' , 'Young' , available_target_name)} />
      </Table.Cell>
      <Table.Cell>
        <Button
          my={1}
          mx={3}
          color='good'
          content="Mature"
          disabled={mature ? false : true}
          onClick={() => act('spawn' , 'Mature' , available_target_name)} />
      </Table.Cell>
      <Table.Cell>
        <Button
          my={1}
          mx={3}
          color='good'
          content="Elder"
          disabled={elder ? false : true}
          onClick={() => act('spawn' , 'Elder' , available_target_name)} />
      </Table.Cell>
      <Table.Cell>
        <Button
          my={1}
          mx={3}
          color='good'
          content="Ancient"
          disabled={ancient ? false : true}
          onClick={() => act('spawn' , 'Ancient' , available_target_name)} />
      </Table.Cell>
    </Table.Row>
  );
};
